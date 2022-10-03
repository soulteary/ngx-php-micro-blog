<?php
date_default_timezone_set('Asia/shanghai');

defined('TEMPLATE_DIR') or define('TEMPLATE_DIR', '/usr/share/nginx/html/templates');
defined('DATA_DIR') or define('DATA_DIR', '/usr/share/nginx/html/data');
defined('WHISPER_PER_PAGE') or define('WHISPER_PER_PAGE', 5);
defined('ERROR_IS_EMPTY') or define('ERROR_IS_EMPTY', '内容不能为空');

if (defined('DATA_DIR')) {
    if (!file_exists(DATA_DIR)) {
        mkdir(DATA_DIR);
    }
} else {
    echo "需要定义数据目录";
    exit;
}

if (!class_exists('Template')) {
    class Template
    {
        protected $dir = TEMPLATE_DIR . DIRECTORY_SEPARATOR;
        protected $vars = array();
        public function __construct($dir = null)
        {
            if ($dir !== null) {
                $this->dir = $dir;
            }
        }
        public function render($file)
        {
            if (file_exists($this->dir . $file)) {
                include $this->dir . $file;
            } else {
                throw new Exception('no template file ' . $file . ' present in directory ' . $this->dir);
            }
        }
        public function __set($name, $value)
        {
            $this->vars[$name] = $value;
        }
        public function __get($name)
        {
            return $this->vars[$name];
        }
    }
}

if (!class_exists('Whisper')) {
    class Whisper
    {
        private function getArgs($key, $method)
        {
            $dataSource = null;
            $isNginxEnv = false;

            if ($method == 'GET') {
                if (function_exists('ngx_query_args')) {
                    $dataSource = ngx_query_args();
                    $isNginxEnv = true;
                } else {
                    $dataSource = $_GET;
                }
            } else {
                if (function_exists('ngx_post_args')) {
                    $dataSource = ngx_post_args();
                    $isNginxEnv = true;
                } else {
                    $dataSource = $_POST;
                }
            }

            if (!isset($dataSource[$key])) {
                return "";
            }

            return $isNginxEnv ? trim(urldecode($dataSource[$key])) : trim($dataSource[$key]);
        }

        private function redir($url)
        {
            if (function_exists('ngx_header_set')) {
                ngx_header_set("Location", $url);
                ngx_exit(NGX_HTTP_MOVED_TEMPORARILY);
            } else {
                header("Location: " . $url);
            }
        }

        public function __construct()
        {
            $content = $this->getArgs('content', 'POST');
            if (empty($content)) {
                $start_time = microtime(true);
                $page = 1;

                $page = $this->getArgs('p', 'GET');
                if (!empty($page)) {
                    $page = (int) filter_var($page, FILTER_SANITIZE_NUMBER_INT);
                    if ($page < 1) {
                        $page = 1;
                    }
                } else {
                    $page = 1;
                }

                $tpl = new Template();
                $tpl->data = $this->loadData($page);

                ob_start();
                $tpl->render('main.html');
                ob_end_flush();

                $end_time = microtime(true);
                echo "\n<!-- program processing time: " . round($end_time - $start_time, 3) . "s -->";
            } else {
                $content = htmlentities((string) filter_var($content, FILTER_SANITIZE_SPECIAL_CHARS));
                $this->postWhisper($content);
            }
        }

        private function postWhisper($content)
        {
            $date = date('Y-m-d g:i:s A');
            $filename = DATA_DIR . DIRECTORY_SEPARATOR . date('YmdHis') . ".txt";
            $file = fopen($filename, "w+");
            $content = $date . "\n" . $content . "\n";
            fwrite($file, $content);
            fclose($file);
            $this->redir("/");
        }

        private function loadData($page)
        {
            $result = [
                'whispers' => [],
                'pagination' => ['hide' => true],
            ];

            $files = [];
            if ($handle = @opendir(DATA_DIR)) {
                while ($file = readdir($handle)) {
                    if (!is_dir($file)) {
                        $files[] = $file;
                    }
                }
            }
            rsort($files);

            $total = sizeof($files);
            if ($total == 0) {
                return $result;
            }

            $page = $page - 1;
            $start = $page * WHISPER_PER_PAGE;
            if (($start + WHISPER_PER_PAGE) > $total) {
                $last = $total;
            } else {
                $last = $start + WHISPER_PER_PAGE;
            }

            for ($i = $start; $i < $last; $i++) {
                $raw = file(DATA_DIR . DIRECTORY_SEPARATOR . $files[$i]);

                $date = trim($raw[0]);
                unset($raw[0]);

                $content = "";
                foreach ($raw as $value) {
                    $content .= $value;
                }
                $data = array(
                    'date' => $date,
                    'content' => html_entity_decode($content),
                );
                $result['whispers'][] = $data;
            }

            $result['pagination'] = $this->getPagination($start, $last, $page, $total);
            return $result;
        }

        private function getPagination($start, $last, $page, $total)
        {
            if ($total <= WHISPER_PER_PAGE) {
                return ['hide' => true];
            }

            $page = $page + 1;
            $next = 0;
            $prev = 0;

            if ($start == 0) {
                if ($last < $total) {
                    $next = $page + 1;
                }
            } else {
                if ($last < $total) {
                    $next = $page + 1;
                    $prev = $page - 1;
                } else {
                    $prev = $page - 1;
                }
            }

            return [
                'hide' => false,
                'prev' => $prev,
                'next' => $next,
                'page' => $page,
                'last' => ceil($total / 5),
            ];
        }
    }
}

new Whisper();

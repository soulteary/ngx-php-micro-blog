
for i in {1..3}
do
  curl 'http://localhost:8090/' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'content=%E5%B0%86%E8%BF%9B%E9%85%92%EF%BC%8C%E6%9D%AF%E8%8E%AB%E5%81%9C%E3%80%82'
  sleep 1
  curl 'http://localhost:8090/' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'content=%E5%A4%A9%E7%94%9F%E6%88%91%E6%9D%90%E5%BF%85%E6%9C%89%E7%94%A8%EF%BC%8C%E5%8D%83%E9%87%91%E6%95%A3%E5%B0%BD%E8%BF%98%E5%A4%8D%E6%9D%A5%E3%80%82'
  sleep 1
  curl 'http://localhost:8090/' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'content=%E4%BA%BA%E7%94%9F%E5%BE%97%E6%84%8F%E9%A1%BB%E5%B0%BD%E6%AC%A2%EF%BC%8C%E8%8E%AB%E4%BD%BF%E9%87%91%E6%A8%BD%E7%A9%BA%E5%AF%B9%E6%9C%88%E3%80%82'
  sleep 1
  curl 'http://localhost:8090/' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'content=%E5%90%9B%E4%B8%8D%E8%A7%81%E9%AB%98%E5%A0%82%E6%98%8E%E9%95%9C%E6%82%B2%E7%99%BD%E5%8F%91%EF%BC%8C%E6%9C%9D%E5%A6%82%E9%9D%92%E4%B8%9D%E6%9A%AE%E6%88%90%E9%9B%AA%E3%80%82'
  sleep 1
  curl 'http://localhost:8090/' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'content=%E5%90%9B%E4%B8%8D%E8%A7%81%E9%BB%84%E6%B2%B3%E4%B9%8B%E6%B0%B4%E5%A4%A9%E4%B8%8A%E6%9D%A5%EF%BC%8C%E5%A5%94%E6%B5%81%E5%88%B0%E6%B5%B7%E4%B8%8D%E5%A4%8D%E5%9B%9E%E3%80%82'
  sleep 1
done
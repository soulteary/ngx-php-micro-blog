!function(e,n){"object"==typeof exports&&"undefined"!=typeof module?module.exports=n():"function"==typeof define&&define.amd?define(n):e.twas=n()}(this,function(){var e=function(e,n){return n>=e?Math.floor(n/e):0};return function(n,o){o||(o=Date.now());var t=(o-n)/1e3,r=e(60,t),f=e(60,r),u=e(24,f),a=e(7,u),i=e(30,u),d=e(12,i),c=d,s="year";if(t<=1)return"just now";d>0?(c=d,s="year"):i>0?(c=i,s="month"):a>0?(c=a,s="week"):u>0?(c=u,s="day"):f>0?(c=f,s="hour"):r>0?(c=r,s="minute"):t>0&&(c=t,s="second");var y=Math.floor(c);return(1===y?c===f?"an":"a":y)+" "+s+(y>1?"s":"")+" ago"}});

Array.from(document.querySelectorAll('.timeago')).forEach(function (node) {
    node.innerText = twas(new Date(node.getAttribute('data-value')))
});
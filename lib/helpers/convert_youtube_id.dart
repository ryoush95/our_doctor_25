String convertUrlToId(String url) {
  var videoId = url.split('v=')[1];
  var ampersandPosition = videoId.indexOf('&');
  if(ampersandPosition != -1) {
    videoId = videoId.substring(0, ampersandPosition);
  }
  return videoId;
}
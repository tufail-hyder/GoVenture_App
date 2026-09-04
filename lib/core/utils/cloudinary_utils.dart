
String optimizedCloudinaryUrl(String url, {int width = 400}) {
  if (!url.contains('res.cloudinary.com') || !url.contains('/upload/')) {
    return url;
  }
  return url.replaceFirst('/upload/', '/upload/w_$width,q_auto,f_auto/');
}
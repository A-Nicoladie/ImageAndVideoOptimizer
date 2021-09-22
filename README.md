# IAVO - Image And Video Optimizer (Windows)

When you need to share media, and you don't need high quality, this script allows you to compress images and videos.

## Installation

- Download the [zip][10] or the [tar.gz][20] package
- Extract it to the folder of your choice on your computer

## Usage

- Put some media files in the folder where the script is located.
- Run one of the scripts
  - `Start Optimization`: to optimize each media file in this folder.
  - `Compare`: to do a low, medium and high quality optimization on each media file in this folder.
  Be careful, it will take three times longer. Try it only on some small files to test.   

## Accepted files

Images : jpg, jpeg, png, bmp, gif, tif, tiff

Videos : avi, mp4, mov, divx, mkv, mpg, webm


## Used programs and documentation

- HandBrakeCLI from [Handbrake][40]     
  Convert all videos files into MP4  
  ℹ [https://handbrake.fr/docs/en/latest/cli/cli-options.html]()  
  
- convert from [ImageMagik][50]  
  Convert images files in PNG  
  ℹ [https://imagemagick.org/script/convert.php]()  
  
- [jpegoptim][60]  
  Optimize JPG files  
  ℹ [https://www.kokkonen.net/tjko/src/man/jpegoptim.txt]()  
  
- [pngquant][70]  
  Optimize PNG files  
  ℹ [https://pngquant.org/#manual]()

## License
[CC0][30]


<!-- LINKS -->

[10]: https://github.com/A-Nicoladie/ImageAndVideoOptimizer/archive/refs/heads/master.zip "Master ZIP file"
[20]: https://github.com/A-Nicoladie/ImageAndVideoOptimizer/archive/refs/heads/master.tar.gz
[30]: https://github.com/A-Nicoladie/ImageAndVideoOptimizer/blob/main/LICENSE "Creative Commons Zero v1.0 Universal"
[40]: https://handbrake.fr "HandBrake"
[50]: https://imagemagick.org "ImageMagik"
[60]: https://www.kokkonen.net/tjko/projects.html "jpegoptim"
[70]: https://pngquant.org/ "pngquant"
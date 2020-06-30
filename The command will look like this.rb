
# ruby

# Where X is the number of lines in the file you want to generate and Y is the number of words in each line. So, to create a file with 100 lines and 4 words in each line you would do:

# ruby -e 'a=STDIN.readlines;100.times do;b=[];4.times do; b << a[rand(a.size)].chomp end; puts b.join(” “); end' < /usr/share/dict/words > file.txt

a='/usr/share/dict/words'.readlines;

100.times do;
    b=[];
    4.times do;
        b << a[rand(a.size)].chomp end;
    puts b.join(” “); end


# This is getting a little complex for a one-liner, but once you understand what’s going on, it is fairly easy to put together. We basically read in the dictionary into an array, then we randomly select words to form a line (getting rid of newlines while we’re at it), we then output our newly created line and we put a loop around the whole thing –  pretty simple.

# With this method you’re very unlikely to ever get repeated lines (although it is technically possible). It takes about 10 seconds to generate a 100Mb file (around 1 million lines with 12 words per line), which is comparable to some of our other methods. The lines we produce will not make any semantic sense but will be made up of real words and will therefore be readable.

# There you go, you’re now able to generate any kind of data file you want (large or small) for your testing purposes. If you know of any other funky ways to generate files in Linux, then please share and don’t forget to grab my RSS feed if you haven’t already. Enjoy!

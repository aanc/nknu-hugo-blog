+++
date = "2014-05-17T19:05:36"
draft = "false"
title = "How to sync your subtitles with media player classic"
slug = "sync-your-subtitles-with-mpc-hc"

+++

Sometimes when you download a video on the internet, you get subtitles on a separate file (ie. from [Open Subtitles](http://www.opensubtitles.org/), [Subscene](http://subscene.com/), [addic7ed](http://www.addic7ed.com/), etc...), and they are not always perfectly sync'ed. If you're using [Media Player Classic](http://mpc-hc.org/), you can fix that pretty easily with its "Sub resync" feature.  Open your video with Media Player Classic and load your subtitles, then hit `ctrl` + `6` (or `View -> Subresync`) to open the sub-resync console.
Now find a line in the subtitles that match what is being said on the video, right-click the line on the "Time" colum, and select `Current` (or hit `F5`). You can see that the timings in the subtitle file have been adjusted.

![](/content/images/2014/May/AirForceOne-MPC-HC.png)

Best part is that you can save those modifications directly in the subtitle file by going to `File -> Save subtitles`, so next time you play that video, you will not have to do that manipulation all over again.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- Test ad -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="7479486209"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
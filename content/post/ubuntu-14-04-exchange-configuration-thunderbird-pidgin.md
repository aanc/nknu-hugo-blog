+++
date = "2014-04-23T22:49:27"
draft = "false"
title = "Ubuntu 14.04 Exchange configuration, with Thunderbird and Pidgin"
slug = "ubuntu-14-04-exchange-configuration-thunderbird-pidgin"
tags = ["linux","ubuntu","thunderbird","pidgin","howto","exchange","davmail","14.04"]

+++

A lot of companies are using Microsoft's Exchange for their communications, with Outlook for the mails/agenda and Lync for instant messaging, and those are common blocking points when one want to switch to Linux on his primary work computer. An easy workaround would be to user Outlook Web Access, but it lacks some features (notifications, desktop integration, ...) and it's not always very convenient (you can't use its advanced features if you're using Chrome for example). However it is possible to have a fully functionnal mail/calendar/IM on Linux, able to connect to the Exchange ecosystem of your company, using Davmail as a gateway, Thunderbird as email and agenda client, and pidgin as instant messenging client. Let's see how we can do that on an Ubuntu 14.04.

1. [Davmail: the bridge between two worlds](#davmail)
2. [Thunderbird: our new Outlook](#thunderbird)
	* [Mail](#mail)
    * [Agenda](#agenda)
    * [Address book](#address-book)
3. [Replacing Lync with Pidgin](#pidgin)

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

### <span id="davmail">Davmail: the bridge between two worlds</span>

The first thing we have to do is to find a way to communicate with the Exchange server. That's what [DavMail](http://davmail.sourceforge.net/) do. According to its official website:

> DavMail is a POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway allowing users to use any mail/calendar client (e.g. Thunderbird with Lightning or Apple iCal) with an Exchange server, even from the internet or behind a firewall through Outlook Web Access. DavMail now includes an LDAP gateway to Exchange global address book and user personal contacts to allow recipient address completion in mail compose window and full calendar support with attendees free/busy display.

First thing we need to do is to install it. You can get it [from its official download page](http://sourceforge.net/projects/davmail/files/). Once downloaded, install it by either double clicking the file, or by opening a terminal and typing:

	sudo dpkg -i davmail_4.4.1-2225-1_all.deb

*(Replace the version with the actual version of the file you downloaded)*

Once installed, you can open it from the Dash (hit `Super` and then type "Davmail") or from the console (just type `davmail`). You can keep the default settings for everything except the "URL OWA (Exchange)" field, where you need to put your Outlook Web Access URL.

><span id="find-out-owa-url"><strong>Finding out your OWA URL:</strong></span> you can ask your admin, or try to guess it with trial and error: depending on your version of Exchange it should be something like `https://<domain.net|server>/exchange` or `https://<domain.net|server>/owa`. You can find which server/domain you need to use by digging into your Outlook properties. In the latest version of Outlook, you may find this information by clicking on the "File" tab in the top left corner of the ribbon, then "Information". If it's not there and you're using Lync, you can right-click on its tray icon and select "Configuration informations", it will open a windows full of information, and if you go to the "EWS URL" line, you'll see which server you need to connect to.

<center>
![Davmail - configuration](/content/images/2014/Apr/davmail-config-1.png)
</center>

Hit the save button, and we're done ! You should see a popup saying that Davmail is running.

Note that if you have other people in your organization willing to use davmail as well, you can install on a server and configure it once and for all so everyone can use it.
If you're installing it only for you though, and on your local machine, you'll certainly want it to start with your session. Ubuntu has a dedicated tool for managing startup application, called ... "Startup applications". Open the Dash and type "Startup applications", create a new entry named "Davmail" and just enter "davmail" in the command field.

### <span id="thunderbird">Thunderbird: our new Outlook</span>

[Thunderbird](http://www.mozilla.org/fr/thunderbird/) is pre-installed on Ubuntu 14.04. If it's not installed on your distribution, you can find out how to get it on its [official website](http://www.mozilla.org/fr/thunderbird/).

#### <span id="mails">Mails</span>

1. Open Thunderbird
2. Go to `File −> New -> Existing mail account ...`
3. Fill in the name, email and password fields
4. Click the "Manual configuration" button, and fill in the fields as follow (adapt the following values if you modified the davmail configuration):
    * Incoming:
        * Type: IMAP
        * Server: localhost
        * Port: 1143
        * SSL: None
        * Authentication: normal password
    * Outgoinh:
        * Type: SMTP
        * Server: localhost
        * Port: 1025
        * SSL: None
        * Authentication: normal password
    * Username: your Exchange username, usually what's before the '@' in your email address (but not necessarily). Basically it's the username you're using to login into OWA.
5. Click "Test", and if everything is OK you should be able to click "Done"

![Thunderbird mail account creation](/content/images/2014/Apr/thunderbird-mail-account-setup.png)

At this point Thunderbird should start to fetch your emails from the server, and you should see them appear in your inbox.

#### <span id="agenda">Agenda</span>

For the calendar, we're going to use the following Thunderbird extensions: <strong>Lightning</strong>, which adds agenda capabilities to Thunderbird, and <strong>ExchangeCalendar</strong>, which allow to connect directly to Exchange calendars.

1. In Thunderbird, to to `Tools -> Addons`
2. Use the search field to search for "Lightning"
3. Install it

Now we need to install ExchangeCalendar. It seems that the version available in the store is obsolete. The version used for this guide is 3.2.0-Beta77, if you can't find it in the store (3.2.0-Beta77 or above), I'd suggest to download it directly from [this page](http://www.1st-setup.nl/wordpress/?page_id=551).
Once downloaded, go back to `Tools -> Addons`, click on the little toolbox right before the search area, select "Install from file", and then navigate to the .xpi file you juste downloaded.

![Thunderbird - Install from file](/content/images/2014/Apr/thunderbird-install-addon-from-file.png)

Once those two addons are installed, go back to Thunderbird's main window and perform the following actions:

* Go to `File -> New -> Calendar`
* Select "On the network", then click next
* Select "Microsoft Exchange 2007/2010/2013", then click next

![](/content/images/2014/Apr/thunderbird-add-calendar.png)

* Give a name to the calendar, then click next
* Fill in the fields as follow:
	* Server URL: your EWS URL. You can find it out with [the method used for finding our OWA URL](#find-out-owa-url)
    * Mailbox name: your email address
    * User: your username (the one you use to login into OWA)
    * Domain: your company's domain
    * Shared folder: leave that field empty
* Click the "Verify" button, and if everything is OK hit "Next"

![Thunderbird - Agenda configuration box](/content/images/2014/Apr/thunderbird-new-calendar-2-1.png)

The calendar should now appear in the "Agenda" tab of Thunderbird.

#### <span id="address-book">Address book</span>

If your company is using LDAP for the address book, you can configure Thunderbird to use if with the following steps:

1. In the Thunderbird toolbar, click the "Address Book" button.
2. In the Address Book window, click `File -> New -> LDAP Directory`
3. You may need to ask your administrator to give you the hostname and the Base DN
4. Click "OK", and verify that you can successfully search people in the Address Book

![Thunderbird - Address Book LDAP config](/content/images/2014/Apr/thunderbird-address-book-ldap-config.png)

Once done, you can enable the address auto-completion when writing message in Thunderbird's preferences window (`Edit -> Preferences`): in the "Composition" tab, check "Directory Server" then select the address book you just added.

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

### <span id="pidgin">Replacing Lync with pidgin</span>

In order to have instant messenging available on our linux box, we're going to use pidgin, with the pidgin-sipe plugin (to enable Exchange capabilities), and optionnaly pidgin-libnotify (to have a better integration into our Ubuntu 14.04).

You will need to gather info from your Windows's Lync setup, by right-clicking on its tray icon and opening the "Configuration Informations". From this window, get the server name, you'll need it to setup pidgin.

![Lync - config info 1](/content/images/2014/Apr/pidgin-1.png)
![Lync - config info 2](/content/images/2014/Apr/pidgin-2.png)

If pidgin is not installed on your system, you can install it via the Ubuntu Software Center simply by searching for it, or by opening a terminal and typing:

    sudo apt-get install pidgin pidgin-sipe pidgin-libnotify

Launch pidgin, and go to `Account -> Manage -> Add ...`, and fill in the fields as follow:

* Tab "Essential":
    * Protocol: Office communicator
    * User: your email address
    * Login: the login you use to access OWA
    * Password: your password for that account
* Tab "Advanced":
	* Server: the server you found in your Lync settings
    * Connection type: Auto
    * Encryption: TSL-DSK
* Tab "Proxy":
	* Type: No proxy

Save and connect, you should see your contact list appear.

<strong>Note:</strong> in all my boxes (on Lubuntu 13.10 and Ubuntu 14.04), I've never managed to have pidgin work without setting the `NSS_SSL_CBC_RANDOM_IV` environment variable to 0. Without this variable, I always got a "<strong>Read Error</strong>" at connection.
To set this variable, edit your ~/.profile file and add the following:

    # SSL config for pidgin
    export NSS_SSL_CBC_RANDOM_IV=0`

You will have to logout/login for this parameter to take effect.

And that's it ! Let me know in the comments if something does not work, of if you have a better method. Thanks for reading!

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- In article -->
<ins class="adsbygoogle"
     style="display:inline-block;width:468px;height:60px"
     data-ad-client="ca-pub-9470959665799736"
     data-ad-slot="4075034603"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

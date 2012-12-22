YubiKey Implimentation in Microsft Active Directory
===================================================
This is an implimentation of the Openldap implimentation by Michal Ludvig <http://logix.cz/michal/devel/yubikey-ldap/> applied to Microsft Active Directory.

Notes
-----

You can use tools like ADSI Edit to manage the keys for users.
There are also tutorials on the internet explaining how to crate a dialogue box / context menu tool for updating custom attributes in the Active Directory Server Admin tool. (dsa.msc)

For a complete tutorial on all of this look at:
    <http://www.informit.com/articles/article.aspx?p=169630&seqNum=1>

Implimentation
--------------

Log into a Windows Server 2003 as a domain administrator and start a
command prompt.

Then execute:

    ldifde -i -f path\to\ms-yubikey.ldif -j .

You should see something like:

    6 entries modified successfully
   
    The command has completed successfully

To test if this is all working you could add some kuys using the ADSI Edit snap-in.

* Browse to your Domain -> CN=Users
* Right mouse click the username you want to edit
* Select Properties
* Scroll down to and select YubiKeyId
* Click Edit
* Add values until you are done
* Click OK until you are finished.

Tested
------

1. This ldif was successfully imported into a Samba4 AD from a Windows Server 2003 R2 Client.
2. This ldif was successfully imported into a Windows Server 2003 R2 Active Directory Domain. (IE: No Samba4 or Linux in site.)

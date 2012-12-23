YubiKey Implimentation in Microsft Active Directory
===================================================
This is an implimentation of the Openldap implimentation by Michal Ludvig <http://logix.cz/michal/devel/yubikey-ldap/> applied to Microsft Active Directory.

Notes
-----

You can use tools like ADSI Edit to manage the keys for users.
There are also tutorials on the internet explaining how to crate a dialogue box / context menu tool for updating custom attributes in the Active Directory Server Admin tool. (dsa.msc)

The included updateAdminContextMenu.ldif can be used to apply the required change to the context menu in ADUC.
The included yubikey.vbs script is used by the new Admin Context Menu.

For a complete tutorial on all of this look at:
    <http://www.informit.com/articles/article.aspx?p=169630&seqNum=1>

Attribute and Class Implimentation
----------------------------------

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

Update ADUC User Admin Context Menu
-----------------------------------

Log into a Windows Server 2003 as a domain administrator and start a
command prompt.

Then execute:

    ldifde -i -f path\to\updateAdminContextMenu.ldif

You should see something like:

    2 entries modified successfully

    The command completed successfully

Then copy yubikeyid.vbs to c:\yubikeyid.vbs

To test:

* To test if this works, open up the ADUC snap-in (dsa.msc)
* browse to your Domain -> Users and Computers
* right click on a user
* select YubiKey ID
* A dialogue box should appear where you can enter a semi-colon (;) seperated list of YubiKey IDs
* Click OK to save.
* To test if the key is saved, you can execute these preceeding steps again and view the key(s) displayed in the message box.

Tested
------

1. This ldif was successfully imported into a Samba4 AD from a Windows Server 2003 R2 Client.
2. This ldif was successfully imported into a Windows Server 2003 R2 Active Directory Domain. (IE: No Samba4 or Linux in site.)

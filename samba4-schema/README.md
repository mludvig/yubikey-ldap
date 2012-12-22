YubiKey LDIF Implimentation Into Samba4 Active Directory
=======================================================

This is an implimentation of the Openldap implimentation by Michal Ludvig <http://logix.cz/michal/devel/yubikey-ldap/> applied to Samba4 Active Directory.

CAUTION
-------
This process will permanently modify your schema.  If it breaks you will not be able to recover unless from a backup.  Please backup your schema files before starting.  On a default install they can be found at /usr/local/samba/private/sam.ldb and all the files in /usr/local/samba/private/sam.ldb.d/

yubikeyid.ldif
--------------
    dn: CN=yubiKeyId,CN=Schema,CN=Configuration,dc=samba4,dc=internal
    changetype: add
    objectClass: top
    objectClass: attributeSchema
    attributeID: 1.3.6.1.4.1.40789.2012.11.1.2.1.1
    cn: yubiKeyId
    name: yubiKeyId
    lDAPDisplayName: yubiKeyId
    description: Yubico YubiKey ID
    attributeSyntax: 2.5.5.5
    oMSyntax: 22
    isSingleValued: FALSE

Add the yubiKeyId attribute into the Schema Configuration first with:
    ldbadd -H /usr/local/samba/private/sam.ldb \
      yubikeyid.lidf \
      --option="dsdb:schema update allowed"=true

yubikeyuser.ldif
----------------
    dn: CN=yubiKeyUser,CN=Schema,CN=Configuration,dc=samba4,dc=internal
    changetype: add
    objectClass: top
    objectClass: classSchema
    governsID: 1.3.6.1.4.1.40789.2012.11.1.2.2.1
    cn: yubiKeyUser
    name: yubiKeyUser
    lDAPDisplayName: yubiKeyUser
    description: Yubico YubiKey User
    subClassOf: top
    objectClassCategory: 3
    mayContain: yubiKeyId

Next add the yubiKeyUser class into the Schema Configuration with:
    ldbadd -H /usr/local/samba/private/sam.ldb \
      yubikeyuser.lidf \
      --option="dsdb:schema update allowed"=true

updateUserClass.ldif
--------------------
    dn: CN=User,CN=Schema,CN=Configuration,DC=samba4,DC=internal
    changetype: modify
    add: auxiliaryClass
    auxiliaryClass: yubiKeyUser

Apply the User class update with:
    ldbmodify -H /usr/local/samba/private/sam.ldb \
      updateUserClass.ldif \
      --option="dsdb:schema update allowed"=true

Add YubiKeys to Users
---------------------
An example ldif:
    dn: CN=David Latham,CN=Users,DC=samba4,DC=internal
    changetype: modify
    add: objectClass
    objectClass: yubiKeyUser
    -
    add: yubiKeyId
    yubiKeyId: abcdefgh1234
    yubiKeyId: xyzxyz123456

Apply it with:
    ldapmodify -h samba -f addKeyToUser.ldif

Test it with:
    ldapsearch -h samba -b "CN=David Latham,CN=Users,DC=samba4,DC=internal" yubiKeyId

    SASL/GSSAPI authentication started
    SASL username: administrator@SAMBA4.INTERNAL
    SASL SSF: 56
    SASL data security layer installed.
    # extended LDIF
    #
    # LDAPv3
    # base with scope subtree
    # filter: (objectclass=*)
    # requesting: yubiKeyId
    #

    # David Latham, Users, samba4.internal
    dn: CN=David Latham,CN=Users,DC=samba4,DC=internal
    yubiKeyId: abcdefgh1234
    yubiKeyId: xyzxyz123456

    # search result
    search: 5
    result: 0 Success

    # numResponses: 2
    # numEntries: 1

Acknowledgments
===============
Michal Ludvig for defining the schema.
Microsoft Documentation for information on attributeSyntax, oMSyntax and objecClassCategory

%%%
title = "JSContact: A JSON representation of contact data"
abbrev = "JSContact"
category = "std"
ipr= "trust200902"
area = "Applications"
workgroup = "JMAP"
submissiontype = "IETF"
keyword = ["JSON", "addressbook", "contacts", "cards", "VCARD"]

date = 2020-02-07T10:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-ietf-jmap-jscontact-00"
stream = "IETF"
status = "standard"

[[author]]
initials="R."
surname="Stepanek"
fullname="Robert Stepanek"
organization = "FastMail"
  [author.address]
  email = "rsto@fastmailteam.com"
  [author.address.postal]
  street = "PO Box 234, Collins St West"
  city = "Melbourne"
  code = "VIC 8007"
  country = "Australia"
  region = " "

[[author]]
initials="M."
surname="Loffredo"
fullname="Mario Loffredo"
organization = "IIT-CNR"
  [author.address]
  email = "mario.loffredo@iit.cnr.it"
  [author.address.postal]
  street = "Via Moruzzi,1"
  city = "Pisa"
  code = "56124"
  country = "Italy"
  region = " "
%%%

.# Abstract

This specification defines a data model and JSON representation of contact card information that can be used for data storage and exchange in address book or directory applications. It aims to be an alternative to the vCard data format and to be unambiguous, extendable and simple to process. In contrast to the JSON-based jCard format, it is not a direct mapping from the vCard data model and expands semantics where appropriate.

{mainmatter}

# Introduction

This document defines a data model for contact card data normally used in address book or directory applications and services. It aims to be an alternative to the vCard data format [@!RFC6350] and to provide a JSON-based standard representation of contact card data.

The key design considerations for this data model are as follows:

- Most of the initial set of attributes should be taken from the vCard data format [@!RFC6350] and extensions ([@RFC6473], [@RFC6474], [@RFC6715], [@RFC6869], [@RFC8605]). The specification should add new attributes or value types, or not support existing ones, where appropriate. Conversion between the data formats need not fully preserve semantic meaning.
- The attributes of the cards data represented must be described as a simple key-value pair, reducing complexity of its representation.
- The data model should avoid all ambiguities and make it difficult to make mistakes during implementation.
- Extensions, such as new properties and components, MUST NOT lead to requiring an update to this document.

The representation of this data model is defined in the I-JSON format [@!RFC7493], which is a strict subset of the JavaScript Object Notation (JSON) Data Interchange Format [@!RFC8259]. Using JSON is mostly a pragmatic choice: its widespread use makes JSCard easier to adopt, and the availability of production-ready JSON implementations eliminates a whole category of parser-related interoperability issues.

## Relation to the xCard and jCard formats

The xCard [@!RFC6351] and jCard [@!RFC7095] specifications define alternative representations for vCard data, in XML and JSON format respectively. Both explicitly aim to not change the underlying data model. Accordingly, they are regarded as equal to vCard in the context of this document.

## Terminology

The key words "**MUST**", "**MUST NOT**", "**REQUIRED**", "**SHALL**", "**SHALL NOT**", "**SHOULD**",
"**SHOULD NOT**", "**RECOMMENDED**", "**NOT RECOMMENDED**", "**MAY**", and "**OPTIONAL**" in this
document are to be interpreted as described in BCP 14 [@!RFC2119] [@!RFC8174] when, and only when,
they appear in all capitals, as shown here.

## Vendor-specific Property Extensions and Values

Vendors MAY add additional properties to JSContact objects to support their custom features. The names of these properties MUST be prefixed with a domain name controlled by the vendor to avoid conflict, e.g. "example.com/customprop".

Some JSContact properties allow vendor-specific value extensions. If so, vendor-specific values MUST be prefixed with a domain name controlled by the vendor, e.g. "example.com/customrel".

Vendors are strongly encouraged to register any new property values or extensions that are useful to other systems as well, rather than using a vendor-specific prefix.

# JSCard

MIME type: `application/jscontact+json;type=jscard`

A JSCard object stores information about a person, organization or company.

## Metadata properties

### uid
Type: `String` (mandatory).

An identifier, used to associate the object as the same across different systems, addressbooks and views.  [@!RFC4122] describes a range of established algorithms to generate universally unique identifiers (UUID), and the random or pseudo-random version is recommended.  For compatibility with [@!RFC6350] UIDs, implementations MUST accept both URI and free-form text.

### prodId
Type: `String` (optional).

The identifier for the product that created the JSCard object.

### updated
Type: `String` (optional).

The date and time when the data in this JSCard object was last modified. The timestamp MUST be formatted as specified in [@RFC3339].

### kind
Type: `String` (optional). The kind of the entity the Card represents.

The value MUST be either one of the following values, registered in a future RFC, or a vendor-specific value:

- `individual`: a single person
- `org`: an organization
- `location`: a named location
- `device`: a device, such as appliances, computers, or network elements
- `application`: a software application

### relatedTo

Type: `String[Relation]` (optional).

Relates the object to other JSCard objects.  This is represented as a map of the URI (or single text value) of the related objects to a possibly empty set of relation types. The Relation object has the following properties:

- relation: `String[Boolean]` (optional, default: empty Object)
  Describes how the linked object is related to the linking object.  The relation is defined as a set of relation types.  If empty, the relationship between the two objects is unspecified.
  Keys in the set MUST be one of the RELATED property [@RFC6350] type parameter values, or an IANA-registered value, or a vendor-specific value.
  The value for each key in the set MUST be true.

Note, the Relation object only has one property; it is specified as an object with a single property to allow for extension in the future.


## Name and Organization properties

### fullName
Type: `LocalizedString` (optional).

The full name (e.g. the personal name and surname of an individual, the name of an organization) of the entity represented by this card.

### name
Type: `NameComponent[]` (optional).

The name components of the name of the entity represented by this JSCard. Name components SHOULD be ordered such that their values joined by whitespace produce a valid full name of this entity.

A NameComponent has the following properties:

- value: `String` (mandatory).
  The value of this name component.
- type: `String` (mandatory).
  The type of this name component. Valid name component types are:
  - `prefix`. The value is a honorific title(s), e.g. "Mr", "Ms", "Dr".
  - `personal`. The value is a personal name(s), also known as "first name", "given name".
  - `surname`. The value is a surname, also known as "last name", "family name".
  - `additional`. The value is an additional name, also known as "middle name".
  - `suffix`. The value is a honorific suffix, e.g. "B.A.", "Esq.".
  - `nickname`. The value is a nickname.

### organization
Type: `LocalizedString[]` (optional).

The company or organization name and units associated with this card.
The first entry in the list names the organization, and any following
entries name organizational units.

### jobTitle
Type : `LocalizedString[]` (optional).

The job title(s) or functional position(s) of the entity represented by this card.

### role
Type : `LocalizedString[]` (optional).

The role(s), function(s) or part(s) played in a particular situation by the entity represented by this card. In contrast to a job title, the roles might differ for example in project contexts.

## Contact and Resource properties

### emails
Type: `Resource[]` (optional).

An array of Resource objects where the values are URLs in the `mailto` scheme [@RFC6068] or free-text email addresses. The default value of the `type` property is `email`. If set, the type MUST be `email` or `other`.

### phones
Type: `Resource[]` (optional).

An array of Resource objects where the values are URIs scheme or free-text phone numbers. Typical URI schemes are the [@RFC3966] `tel` or [@RFC3261] `sip` schemes, but any URI scheme is allowed.  Types are:

  - `voice` The number is for calling by voice.
  - `fax` The number is for sending faxes.
  - `pager` The number is for a pager or beeper.
  - `other` The number is for some other purpose. A label property MAY be included to display next to the number to help the user identify its purpose.
     
### online
Type: `Resource[]` (optional).

An array of Resource objects where the values are URIs or usernames associated with the card for online services.
Types are:

  - `uri` The value is a URI, e.g. a website link.
  - `username` The value is a username associated with the entity represented by this card (e.g. for social media, or an IM client). A label property SHOULD be included to identify what service this is for. For compatibility between clients, this label SHOULD be the canonical service name, including capitalisation. e.g. `Twitter`, `Facebook`, `Skype`, `GitHub`, `XMPP`.
  - `other` The value is something else not covered by the above categories. A label property MAY be included to display next to the number to help the user identify its purpose.

### preferredContactMethod
Type : `String` (optional)

Defines the preferred contact method or resource with additional information about this card. The value MUST be the property name of one of the Resource lists: `emails`, `phones`, `online`, `other`.

### preferredContactLanguages
Type : `String[ContactLanguage[]]` (optional)

Defines the preferred languages for contacting the entity associated with this card. The keys in the object MUST be [@!RFC5646] language tags. The values are a (possibly empty) list of contact language preferences for this language.  Also see the definition of the VCARD LANG property (Section 6.4.4., [@!RFC6350]).

A ContactLanguage object has the following properties:

- type: `String` (optional).
  Defines the context of this preference. This could be `work`, `home` or another value.
- preference: `Number` (optional).
  Defines the preference order of this language for the context defined in the type property. If set, the property value MUST be between 1 and 100 (inclusive). Lower values correspond to a higher level of preference, with 1 being most preferred. If not set, the default MUST be to interpret the language as the least preferred in its context. Preference orders SHOULD be unique across language for a specific type.

A valid ContactLanguage object MUST have at least one of its properties set.

## Address and Location properties

### addresses
Type: Address[] (optional).

An array of Address objects, containing physical locations. An Address object has the following properties:

- context: `String` (optional, default `other`).
  Specifies the context of the address information.
  The value MUST be either one of the following values, registered in a future
  RFC, or a vendor-specific value:
  - `private` An address of a residence.
  - `work` An address of a workplace.
  - `billing` An address to be used for billing.
  - `postal` An address to be used for delivering physical items.
  - `other` An address not covered by the above categories.
- label: `String` (optional).
  A label describing the value in more detail.
- fullAddress: `LocalizedString` (optional).
  The complete address, excluding type and label. This property is mainly useful to represent addresses of which the individual address components are unknown, or to provide localized representations.
- street: `String` (optional).
  The street address. This MAY be multiple lines; newlines MUST be preserved.
- extension: `String` (optional)
  The extended address, such as an apartment or suite number, or care-of address.
- locality: `String` (optional).
  The city, town, village, post town, or other locality within which the street address may be found.
- region: `String` (optional).
  The province, such as a state, county, or canton within which the locality may be found.
- country: `String` (optional).
  The country name.
- postOfficeBox: `String` (optional)
  The post office box.
- postcode: `String` (optional).
  The postal code, post code, ZIP code or other short code associated with the address by the relevant country's postal system.
- countryCode: `String` (optional).
  The ISO-3166-1 country code.
- coordinates: `String` (optional) A [@!RFC5870] "geo:" URI for the address.
- timeZone: `String` (optional) Identifies the time zone this address is located in. This SHOULD be a time zone name registered in the [IANA Time Zone Database](https://www.iana.org/time-zones). Unknown time zone identifiers MAY be ignored by implementations.
- isPreferred: Boolean (optional, default: false).
  Whether this Address is the preferred for its type. This SHOULD only be one per type.


## Additional properties

### anniversaries
Type : Anniversary[] (optional).

Memorable dates and events for the entity represented by this card. An Anniversary object has the following properties:

- type: `String` (mandatory).
  Specifies the type of the anniversary. This RFC predefines the following types, but implementations MAY use additional values:
  - `birth`: a birth day anniversary
  - `death`: a death day anniversary
  - `other`: an anniversary not covered by any of the known types.
- label: `String` (optional).
  A label describing the value in more detail, especially if the type property has value `other` (but MAY be included with any type).
- date: `String` (mandatory).
  The date of this anniversary, in the form "YYYY-MM-DD" (any part may be all 0s for unknown) or a [@RFC3339] timestamp.
- place: Address (optional).
  An address associated with this anniversary, e.g. the place of birth or death.

### personalInfo
Type: PersonalInformation[] (optional).

A list of personal information about the entity represented by this card.
A PersonalInformation object has the following properties:

- type: `String` (mandatory).
  Specifies the type for this personal information. Allowed values are:
      - `expertise`: a field of expertise or credential
      - `hobby`: a hobby
      - `interest`: an interest
      - `other`: an information not covered by the above categories
- value: `String` (mandatory).
  The actual information. This generally is free-text, but future specifications MAY restrict allowed values depending on the type of this PersonalInformation.
- level: `String` (optional)
  Indicates the level of expertise, or engagement in hobby or interest. Allowed values are: `high`, `medium` and `low`.

### notes
Type: `LocalizedString[]` (optional).

Arbitrary notes about the entity represented by this card.

### categories
Type: `String[]` (optional).
A list of free-text or URI categories that relate to the card.

## Common JSCard types

### LocalizedString {#localized-string-type}

A LocalizedString object has the following properties:

- value: `String` (mandatory).
  The property value.
- language: `String` (optional).
  The [@!RFC5646] language tag of this value, if any.
- localizations: `String[String]` (optional).
  A map from [@!RFC5646] language tags to the value localized in that language.

### Resource {#resource-type}

A Resource object has the following properties:

- context: `String` (optional)
  Specifies the context in which to use this resource. Pre-defined values are:
  - `private`: The resource may be used to contact the card holder in a private context.
  - `work`: The resource may be used to contact the card holder in a professional context.
  - `other`: The resource may be used to contact the card holder in some other context. A label property MAY be help to identify its purpose.
- type: `String` (optional).
  Specifies the property-specific variant of the resource. This MUST be taken from the set of allowed types specified in the respective contact method property.
- labels: `String[Boolean]` (optional).
  A set of labels that describe the value in more detail, especially if the type property has value `other` (but MAY be included with any type). The keys in the map define the label, the values MUST be `true`.
- value: `String` (mandatory).
  The actual resource value, e.g. an email address or phone number.
- mediaType: `String` (optional).
  Used for properties with URI values. Provides the media type [@!RFC2046] of the resource identified by the URI.
- isPreferred: Boolean (optional, default: false).
  Whether this resource is the preferred for its type. This SHOULD only be one per type.

# JSCardGroup

MIME type: `application/jscontact+json;type=jscardgroup`

A JSCardGroup object represents a named set of JSCards.

## Properties

### uid
Type : `String` (mandatory).

A globally unique identifier. The same requirements as for the JSCard uid property apply.

### name
Type: `String` (optional).

The user-visible name for the group, e.g. "Friends". This may be any UTF-8 string of at least 1 character in length and maximum 255 octets in size. The same name may be used by two different groups.

### cards
Type : `JSCard[]` (mandatory).
The cards in the group. Implementations MUST preserve the order of list entries.


# Implementation Status

NOTE: Please remove this section and the reference to [@!RFC7942] prior
to publication as an RFC.
This section records the status of known implementations of the
protocol defined by this specification at the time of posting of this
Internet-Draft, and is based on a proposal described in
[@!RFC7942]. The description of implementations in this section is
intended to assist the IETF in its decision processes in progressing
drafts to RFCs. Please note that the listing of any individual
implementation here does not imply endorsement by the IETF.
Furthermore, no effort has been spent to verify the information
presented here that was supplied by IETF contributors. This is not
intended as, and must not be construed to be, a catalog of available
implementations or their features. Readers are advised to note that
other implementations may exist.
According to [@!RFC7942], "this will allow reviewers and working groups
to assign due consideration to documents that have the benefit of
running code, which may serve as evidence of valuable experimentation
and feedback that have made the implemented protocols more mature.
It is up to the individual working groups to use this information as
they see fit".

## IIT-CNR/Registro.it

- Responsible Organization: Institute of Informatics and Telematics
of National Research Council (IIT-CNR)/Registro.it
- Location: https://rdap.pubtest.nic.it/
- Description: This implementation includes support for RDAP queries
using data from the public test environment of .it ccTLD. The
RDAP server does not implement any security policy because data
returned by this server are only for experimental testing
purposes. The RDAP server returns responses including JSCard in place of jCard when queries contain the parameter jscard=1.
- Level of Maturity: This is a "proof of concept" research implementation.
- Coverage: This implementation includes all of the features described in this specification.
- Contact Information: Mario Loffredo, mario.loffredo@iit.cnr.it



# IANA Considerations

TBD

# Security Considerations

TBD

{backmatter}

# Translation help

## Location and format of translation files

The translation files are located in [config/locales](../config/locales/). There is one per language and the format used is [yaml](https://en.wikipedia.org/wiki/YAML). The yaml format consists of indented keys on the left and values on the right. Keys are separated from values by colons.

## What we do and don't want to translate

We do want to translate the values in [en.yml](../config/locales/en.yml).

We don't want to translate keys since they provide the mechanism to lookup the correct text to be displayed on the website.

Substitution values are used when there is a dynamic element to the text. For example in the email sent to a user to confirm their signature, the first line says something like _Hello Beyonce_. The yaml entry for this is

```yaml
greeting: Hello %{name}
```

The only text that requires translation is `Hello` but we do need to retain both the key and substitution value. The Spanish translation is `greeting: Hola %{name}`. The entire Spanish translation can be found in [es.yml](../config/locales/es.yml).

HTML markup may also appear in in the text. eg

```yaml
signature_count_html: The current signature count is <strong>twenty two thousand</strong>
```

The only words that require translating are 'The current signature count is twenty two thousand' but we do want to preserve the HTML tags.

## Language specific issues

There may well be instances that require us to do something more to make the translation work. If so please holler.

And finally, many many thanks.

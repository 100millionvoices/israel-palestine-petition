# Translation help

## Translation file

The format of the translation file is [yaml](https://en.wikipedia.org/wiki/YAML). The yaml format consists of keys on the left and values to the right. Keys are separated from values by colons.

The file we would like translated is [en.yml](../config/locales/en.yml).

We don't want to translate keys since they provide the mechanism to lookup the correct text to be displayed on the website. We do want to translate values which is the text immediately on the right of the keys. So for the following line:

```yaml
  question_html: Can I sign the petition more than once?
```

we only want to translate the text `Can I sign the petition more than once?`.

Substitution values are used when there is a dynamic element to the text. For example in the email sent to a user to confirm their signature, the first line could be _Hello Beyonce_. The yaml entry for this is

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

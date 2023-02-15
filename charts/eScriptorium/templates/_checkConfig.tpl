{{/*
Template for checking configuration

The messages templated here will be combined into a single `fail` call. This creates a means for the user to receive all messages at one time, instead of a frustrating iterative approach.

- Pick a location for the new check.
  + Checks of a group reside in a sub file, `_checkConfig_xxx.tpl`.
  + If there isn't a group for that check yet, put it at the end of this file
  + If there are more than 1 check of a same group, extract those checks into a new
  file following the above format. Don't forget to extract the tests too.
- `define` a new template, prefixed `escriptorium.checkConfig.`
- Check for known problems in configuration, and directly output messages (see message format below)
- Add a line to `escriptorium.checkConfig` to include the new template.

Message format:

**NOTE**: The `if` statement preceding the block should _not_ trim the following newline (`}}` not `-}}`), to ensure formatting during output.

```
component:
    MESSAGE
```
*/}}
{{/*
Compile all warnings into a single message, and call fail.

Due to gotpl scoping, we can't make use of `range`, so we have to add action lines.
*/}}
{{- define "escriptorium.checkConfig" -}}
{{- $messages := list -}}
{{/* add templates here */}}

{{/* other checks */}}
{{- $messages = append $messages (include "escriptorium.checkConfig.pgConfig" .) -}}
{{- $messages = append $messages (include "escriptorium.checkConfig.pGandRedisCIonly" .) -}}
{{- $messages = append $messages (include "escriptorium.checkConfig.redisHost" .) -}}
{{- $messages = append $messages (include "escriptorium.checkConfig.redisSslscheme" .) -}}
{{- $messages = append $messages (include "escriptorium.checkConfig.persistenceEnabled" .) -}}

{{- /* prepare output */}}
{{- $messages = without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- /* print output */}}
{{- if $message -}}
{{-   printf "\nCONFIGURATION CHECKS:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Ensure that redis host is set */}}
{{- define "escriptorium.checkConfig.redisHost" -}}
{{- if not .Values.checkConfig.skipEnvValues }}
{{- if and (not .Values.redis.enabled) (not .Values.global.redisConfig.host) -}}
eScriptorium:
  Redis: Redis is required for eScriptorium. Please set Redis host in `.Values.global.redisConfig.host`
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END escriptorium.checkConfig.redisHost */}}

{{/* Ensure that postgresql host is set */}}
{{- define "escriptorium.checkConfig.pgConfig" -}}
{{- if not .Values.checkConfig.skipEnvValues }}
{{- if (not .Values.postgresql.enabled) -}}
{{- if (not .Values.global.pgConfig.host) -}}
eScriptorium:
  PostgreSQL: PostgreSQL is required for eScriptorium. Please set PostgreSQL host in `.Values.global.pgConfig.host`
{{ end -}}
{{- if (not .Values.global.pgConfig.dbName) -}}
eScriptorium:
  PostgreSQL: Please set database name in `.Values.global.pgConfig.dbName`
{{ end -}}
{{- if (not .Values.global.pgConfig.userName) -}}
eScriptorium:
  PostgreSQL: Please set username in `.Values.global.pgConfig.userName`
{{ end -}}
{{- if or (not .Values.global.pgConfig.password.secretName) (not .Values.global.pgConfig.password.secretKey) -}}
eScriptorium:
  PostgreSQL: Please ensure that PostgreSQL's password was uploaded in k8s secrets and expose it in `.Values.global.pgConfig.password.secretName` and `.Values.global.pgConfig.password.secretKey`
{{ end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END escriptorium.checkConfig.pgConfig */}}

{{/* Ensure that "rediss" scheme used in connection string */}}
{{- define "escriptorium.checkConfig.redisSslscheme" -}}
{{- if and (.Values.global.redisConfig.ssl.redisSslSecretName) (not (hasPrefix "rediss://" .Values.global.redisConfig.host)) -}}
eScriptorium:
  Redis: In the case if you're using Redis with TLS it's necessary to define the scheme "rediss://" in `.Values.global.redisConfig.host`
{{- end -}}
{{- end -}}
{{/* END escriptorium.checkConfig.redisSslscheme */}}

{{/* Ensure persistence was enabled */}}
{{- define "escriptorium.checkConfig.persistenceEnabled" -}}
{{- if (not .Values.global.persistence.enabled) -}}
eScriptorium:
  Persistence: You haven't specified a persistence configuration. Data export function will not be supported.
  Data will be persisted on the node running this container, but all data will be lost if this node goes away.
{{- end -}}
{{- end -}}
{{/* END escriptorium.checkConfig.persistenceEnabled */}}

{{/* Ensure that PG and Redis are not used in Production */}}
{{- define "escriptorium.checkConfig.pGandRedisCIonly" -}}
{{- if (not .Values.ci) -}}
{{- if or .Values.redis.enabled .Values.postgresql.enabled }}
eScriptorium:
  Redis/PostgreSQL: provided Helm chart dependencies should be used only for CI purposes.
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END escriptorium.checkConfig.pGandRedisCIonly */}}
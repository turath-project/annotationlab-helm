{{/*
Expand the name
*/}}
{{- define "app.name" -}}
{{- default "escriptorium-app" .Values.app.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "app-ws.name" -}}
{{- default "escriptorium-ws" .Values.app.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "celery.name" -}}
{{- default "celery" .Values.celery.NameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "pvc.name" -}}
{{- "pvc" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "secrets.name" -}}
{{- "secrets" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the PVC name (only in standalone mode)
*/}}
{{- define "pvc.claimName" -}}
{{- if and .Values.global.persistence.config.volume.existingClaim }}
    {{- printf "%s" (tpl .Values.global.persistence.config.volume.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "pvc.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.app.FullnameOverride }}
{{- .Values.app.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "escriptorium-app" .Values.app.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "app-ws.fullname" -}}
{{- $name := "escriptorium-ws" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "celery.fullname" -}}
{{- if .Values.celery.FullnameOverride }}
{{- .Values.celery.FullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "celery" .Values.celery.FullnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "pvc.fullname" -}}
{{- $name := "pvc" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "secrets.fullname" -}}
{{- $name := "secrets" }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "escriptorium.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for app
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "escriptorium.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if or (.Values.global.image.tag) (.Chart.AppVersion) }}
app.kubernetes.io/version: {{ coalesce .Values.global.image.tag .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for app
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for app-ws
*/}}
{{- define "app-ws.labels" -}}
helm.sh/chart: {{ include "escriptorium.chart" . }}
{{ include "app-ws.selectorLabels" . }}
{{- if or (.Values.global.image.tag) (.Chart.AppVersion) }}
app.kubernetes.io/version: {{ coalesce .Values.global.image.tag .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for app-ws
*/}}
{{- define "app-ws.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app-ws.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for pvc
*/}}
{{- define "pvc.labels" -}}
helm.sh/chart: {{ include "escriptorium.chart" . }}
{{ include "pvc.selectorLabels" . }}
{{- if or (.Values.global.image.tag) (.Chart.AppVersion) }}
app.kubernetes.io/version: {{ coalesce .Values.global.image.tag .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for pvc
*/}}
{{- define "pvc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pvc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for pvc
*/}}
{{- define "secrets.labels" -}}
helm.sh/chart: {{ include "escriptorium.chart" . }}
{{ include "secrets.selectorLabels" . }}
{{- if or (.Values.global.image.tag) (.Chart.AppVersion) }}
app.kubernetes.io/version: {{ coalesce .Values.global.image.tag .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for pvc
*/}}
{{- define "secrets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "secrets.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for celery
*/}}
{{- define "celery.labels" -}}
helm.sh/chart: {{ include "escriptorium.chart" . }}
{{ include "celery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ coalesce .Values.global.image.tag .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for celery
*/}}
{{- define "celery.selectorLabels" -}}
app.kubernetes.io/part-of: escriptorium
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the app service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.app.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.app.serviceAccount.name }}
{{- else }}
{{- default "ls" .Values.app.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the celery service account to use
*/}}
{{- define "celery.serviceAccountName" -}}
{{- if .Values.celery.serviceAccount.create }}
{{- default (include "celery.fullname" .) .Values.celery.serviceAccount.name }}
{{- else }}
{{- default "celery" .Values.celery.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "tplvalues.render" -}}
{{- if typeIs "string" .value }}
    {{- tpl .value .context }}
{{- else }}
    {{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}

{{/*{{- define "app.endpoint" -}}*/}}
{{/*{{- if .Values.app.ingress.enabled }}http{{ if $.Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}*/}}
{{/*{{- else }}*/}}
{{/*{{- include "app.fullname" . }}:{{ .Values.app.service.port }}*/}}
{{/*{{- end }}*/}}
{{/*{{- end}}*/}}

{{/*
Set's common environment variables
*/}}
{{- define "app.common.envs" -}}
            {{- if .Values.app.ingress.enabled }}
            - name: DOMAIN
              value: "{{ .Values.app.ingress.host }}"
            {{- end }}
            {{- if .Values.app.ingress.enabled }}
            - name: CSRF_TRUSTED_ORIGINS
              value: http{{ if .Values.app.ingress.tls }}s{{ end }}://{{ .Values.app.ingress.host }}
            {{- else }}
              value: http://localhost:8080
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.USE_X_FORWARDED_HOST }}
            - name: USE_X_FORWARDED_HOST
              value: "True"
            {{- end }}
            - name: SITE_NAME
              value: {{ .Values.global.site_name }}
            {{- if not .Values.global.extraEnvironmentVars.SECRET_KEY }}
            - name: SECRET_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ include "secrets.fullname" . }}
                  key: django-secret-key
            {{- end }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.auth.database ) }}
            - name: POSTGRES_DB
              value: {{ .Values.postgresql.auth.database }}
            {{- else }}
            {{- if .Values.global.pgConfig.dbName }}
            - name: POSTGRES_DB
              value: {{ .Values.global.pgConfig.dbName }}
            {{- end }}
            {{- end }}
            {{- if .Values.global.pgConfig.host }}
            - name: SQL_HOST
              value: {{ .Values.global.pgConfig.host }}
            {{- else }}
            {{- if .Values.postgresql.enabled }}
            - name: SQL_HOST
              value: {{ .Release.Name }}-postgresql-hl.{{ .Release.Namespace }}.svc.{{ .Values.clusterDomain }}
            {{- end }}
            {{- end }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.servicePort) }}
            - name: SQL_PORT
              value: {{ .Values.postgresql.servicePort | quote }}
            {{- else }}
            {{- if .Values.global.pgConfig.port }}
            - name: SQL_PORT
              value: {{ .Values.global.pgConfig.port | quote }}
            {{- end }}
            {{- end }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.auth.username) }}
            - name: POSTGRES_USER
              value: {{ .Values.postgresql.auth.username}}
            {{- else }}
            {{- if .Values.global.pgConfig.userName }}
            - name: POSTGRES_USER
              value: {{ .Values.global.pgConfig.userName }}
            {{- end }}
            {{- end }}
            {{- if (and .Values.postgresql.enabled .Values.postgresql.auth.password) }}
            - name: POSTGRES_PASSWORD
              value: {{ .Values.postgresql.auth.password }}
            {{- else }}
            {{- if (and .Values.global.pgConfig.password.secretName .Values.global.pgConfig.password.secretKey) }}
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.global.pgConfig.password.secretName }}
                  key: {{ .Values.global.pgConfig.password.secretKey }}
            {{- end }}
            {{- end }}
            {{- if .Values.global.redisConfig.host }}
            - name: REDIS_HOST
              value: {{ .Values.global.redisConfig.host }}
            {{- else }}
            {{- if .Values.redis.enabled }}
            - name: REDIS_HOST
              value: {{ .Release.Name }}-redis-headless.{{ .Release.Namespace }}.svc.{{ .Values.clusterDomain }}
            {{- end }}
            {{- end }}
            {{- if .Values.global.redisConfig.port }}
            - name: REDIS_PORT
              value: {{ .Values.global.redisConfig.port }}
            {{- else }}
            - name: REDIS_PORT
              value: "6379"
            {{- end }}
            {{- if (and .Values.redis.enabled .Values.redis.auth.enabled .Values.redis.auth.password) }}
            - name: REDIS_PASSWORD
              value: {{ .Values.redis.auth.password }}
            {{- else }}
            {{- if (and .Values.global.redisConfig.password.secretName .Values.global.redisConfig.password.secretKey) }}
            - name: REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.global.redisConfig.password.secretName }}
                  key: {{ .Values.global.redisConfig.password.secretKey }}
            {{- end }}
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.KRAKEN_TRAINING_LOAD_THREADS }}
            - name: KRAKEN_TRAINING_LOAD_THREADS
              value: "8"
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.DJANGO_SU_NAME }}
            - name: DJANGO_SU_NAME
              value: admin
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.DJANGO_SU_EMAIL }}
            - name: DJANGO_SU_EMAIL
              value: noreply@mydomain.com
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.DJANGO_FROM_EMAIL }}
            - name: DJANGO_FROM_EMAIL
              value: noreply@mydomain.com
            {{- end }}
            {{- if not .Values.global.extraEnvironmentVars.DJANGO_SU_PASSWORD }}
            - name: DJANGO_SU_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ include "secrets.fullname" . }}
                  key: django-su-password
            {{- end }}
            {{- if .Values.global.extraEnvironmentVars -}}
            {{- range $key, $value := .Values.global.extraEnvironmentVars }}
            - name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
              value: {{ $value | quote }}
            {{- end }}
            {{- end }}
            {{- if .Values.global.extraEnvironmentSecrets -}}
            {{- range $key, $value := .Values.global.extraEnvironmentSecrets }}
            - name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
              valueFrom:
                secretKeyRef:
                  name: {{ $value.secretName }}
                  key: {{ $value.secretKey }}
            {{- end }}
            {{- end }}
{{- end -}}

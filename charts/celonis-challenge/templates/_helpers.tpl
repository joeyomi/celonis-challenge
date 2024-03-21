{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "celonis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "celonis.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "celonis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "celonis.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "celonis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "celonis.labels" -}}
helm.sh/chart: {{ include "celonis.chart" . }}
{{ include "celonis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: celonis
{{- end }}

{{/*
Selector labels
*/}}
{{- define "celonis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "celonis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common deployment strategy definition
*/}}
{{- define "celonis.strategy" -}}
{{- $preset := . -}}
{{- if (eq (toString $preset.type) "Recreate") }}
type: Recreate
{{- else if (eq (toString $preset.type) "RollingUpdate") }}
type: RollingUpdate
{{- with $preset.rollingUpdate }}
rollingUpdate:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Return Celonis API Secret Name
*/}}
{{- define "celonis.apiKeySecretName" -}}
    {{- if .Values.celonis.existingApiKeySecret -}}
    {{- print .Values.celonis.existingApiKeySecret -}}
    {{- else -}}
    {{- printf "%s-%s" (include "celonis.fullname" .) "api-key" -}}
    {{- end -}}
{{- end -}}

{{/*
Return Celonis API Secret key
*/}}
{{- define "celonis.apiKeySecretKey" -}}
    {{- if .Values.celonis.existingApiKeySecretKey -}}
    {{- print .Values.celonis.existingApiKeySecretKey -}}
    {{- else -}}
    {{- print "celonis-api-key" -}}
    {{- end -}}
{{- end -}}
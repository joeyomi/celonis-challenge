# Celonis Platform Engineering Challenge

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![AppVersion: 1.0.1](https://img.shields.io/badge/AppVersion-1.0.1-informational?style=flat-square)

## TL;DR

### Installation
```sh
helm repo add joeyomi https://joeyomi.github.io/celonis-challenge/
helm install celonis-challenge joeyomi/celonis-challenge
```

## Source Code

* <https://github.com/joeyomi/celonis-challenge>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| joeyomi | <joseph.oyomi11@gmail.com> | <https://github.com/joeyomi/> |

## Installing the Chart

To install the chart with the release name `celonis-challenge`:

```sh
helm install celonis-challenge joeyomi/celonis-challenge
```

The command deploys the app on the kubernetes cluster in the default configuration. 

The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `celonis-challenge` deployment:

```sh
helm uninstall celonis-challenge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration and installation details

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install celonis-challenge \
  --set ingress.enabled=true \
  --set ingress.hostname=celonis.get-dev.online
  joeyomi/celonis-challenge
```
The above command enables ingress for the app.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
helm install celonis-challenge -f values.yaml joeyomi/celonis-challenge
```

Example fully configured `values.yaml`:

```yaml
# values.yaml

ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    # Health Check Settings
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/tags: Name=celonis-ingress
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: "15"
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: "5"
    alb.ingress.kubernetes.io/success-codes: "200"
    alb.ingress.kubernetes.io/healthy-threshold-count: "2"
    alb.ingress.kubernetes.io/unhealthy-threshold-count: "2"
    # Route53 Settings
    external-dns.alpha.kubernetes.io/hostname: celonis.get-dev.online
  ingressClassName: "alb"
  path: /
  pathType: Prefix
  hostname: celonis.get-dev.online
```

### Ingress

This chart provides support for Ingress resources. 
If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) is installed on the cluster, that Ingress controller can be used to serve the app.

To enable Ingress integration, set `ingress.enabled` to `true`. 
The `ingress.hostname` property can be used to set the host name. 
The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.

## Parameters
## Overrides

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override `"celonis"` |
| nameOverride | string | `"celonis"` | Provide a name in place of `celonis` |

## File Server parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| celonis.apiKey | string | `"dev"` | Celonis API Key |
| celonis.existingApiKeySecret | string | `""` | Name of an existing secret resource containing the celonis API credentials |
| celonis.existingApiKeySecretKey | string | `"celonis-api-key"` | Name of the existing secret's key containing the celonis API credentials |

## Image parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy for Celonis |
| image.repository | string | `"ghcr.io/joeyomi/celonis-challenge"` | Repository to use for Celonis |
| image.tag | string | `""` (defaults to chart appVersion) | Tag to use for Celonis |
| imagePullSecrets | list | `[]` | Secrets with credentials to pull images from a private registry |

## Deployment parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Assign custom [affinity] rules to the deployment |
| autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for Celonis |
| autoscaling.maxReplicas | int | `5` | Maximum number of replicas for Celonis [HPA] |
| autoscaling.metrics | list | `[]` | Configures custom HPA metrics for Celonis Ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas for Celonis [HPA] |
| autoscaling.targetCPUUtilizationPercentage | int | `50` | Average CPU utilization percentage for Celonis [HPA] |
| autoscaling.targetMemoryUtilizationPercentage | int | `50` | Average memory utilization percentage for Celonis [HPA] |
| containerPorts.http | int | `8080` | celonis container port |
| containerSecurityContext | object | See [values.yaml] | Celonis container-level security context |
| deploymentAnnotations | object | `{}` | Annotations to be added to celonis Deployment |
| deploymentStrategy | object | `{}` | Deployment strategy to be added to the celonis Deployment |
| dnsConfig | object | `{}` | [DNS configuration] |
| dnsPolicy | string | `"ClusterFirst"` | Alternative DNS policy for Celonis pods |
| env | list | `[]` | Environment variables to pass to Celonis |
| envFrom | list | `[]` (See [values.yaml]) | envFrom to pass to Celonis |
| extraArgs | list | `[]` | Additional command line arguments to pass to Celonis |
| hostAliases | list | `[]` | Mapping between IP and hostnames that will be injected as entries in the pod's hosts files |
| hostNetwork | bool | `false` | Host Network for Celonis pods |
| lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your celonis container Specifying this will disable pulling models on container start-up |
| livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| nodeSelector | object | `{}` | [Node selector] |
| pdb.annotations | object | `{}` | Annotations to be added to Celonis pdb |
| pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for Celonis |
| pdb.labels | object | `{}` | Labels to be added to Celonis pdb |
| pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). |
| pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| podAnnotations | object | `{}` | Annotations to be added to celonis pods |
| podLabels | object | `{}` | Labels to be added to celonis pods |
| priorityClassName | string | `""` | Priority class for Celonis pods |
| readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| replicas | int | `1` | The number of celonis pods to run |
| resources | object | `{}` | Resource limits and requests for Celonis |
| revisionHistoryLimit | int | `3` | Number of old deployment ReplicaSets to retain. The rest will be garbage collected. |
| securityContext | object | `{}` (See [values.yaml]) | Toggle and define pod-level security context. |
| terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| tolerations | list | `[]` | [Tolerations] for use with node taints |
| topologySpreadConstraints | list | `[]` | Assign custom [TopologySpreadConstraints] rules to Celonis # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| volumeMounts | list | `[]` | Additional volumeMounts to the celonis container |
| volumes | list | `[]` | Additional volumes to the celonis pod |

## Service parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.annotations | object | `{}` | celonis service annotations |
| service.externalIPs | list | `[]` | celonis service external IPs |
| service.externalTrafficPolicy | string | `""` | Denotes if this Service desires to route external traffic to node-local or cluster-wide endpoints |
| service.labels | object | `{}` | celonis service labels |
| service.loadBalancerIP | string | `""` | LoadBalancer will get created with the IP specified in this field |
| service.loadBalancerSourceRanges | list | `[]` | Source IP ranges to allow access to service from |
| service.nodePortHttp | int | `30080` | celonis service http port for NodePort service type (only if `celonis.service.type` is set to "NodePort") |
| service.servicePortHttp | int | `80` | celonis service http port |
| service.servicePortHttpName | string | `"http"` | celonis service http port name, can be used to route traffic via istio |
| service.sessionAffinity | string | `""` | Used to maintain session affinity. Supports `ClientIP` and `None` |
| service.type | string | `"ClusterIP"` | celonis service type |
| serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | Automount API credentials for the Service Account |
| serviceAccount.create | bool | `true` | Create celonis service account |
| serviceAccount.labels | object | `{}` | Labels applied to created service account |
| serviceAccount.name | string | `"celonis"` | celonis service account name |

## Persistence parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent Volume Access Modes |
| persistence.annotations | object | `{}` | Persistent Volume Claim annotations |
| persistence.dataSource | object | `{}` | Custom PVC data source |
| persistence.enabled | bool | `true` | Create a PVC for Celonis (empty-dir will be used if not specified) |
| persistence.existingClaim | string | `""` | The name of an existing PVC to use for persistence |
| persistence.selector | object | `{}` | Selector to match an existing Persistent Volume for Celonis data PVC # If set, the PVC can't have a PV dynamically provisioned for it |
| persistence.size | string | `"4Gi"` | Size of data volume |
| persistence.storageClass | string | `""` | Storage class of backing PVC |

## Service account parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | Automount API credentials for the Service Account |
| serviceAccount.create | bool | `true` | Create celonis service account |
| serviceAccount.labels | object | `{}` | Labels applied to created service account |
| serviceAccount.name | string | `"celonis"` | celonis service account name |

## Ingress parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.annotations | object | `{}` | Additional ingress annotations |
| ingress.enabled | bool | `false` | Enable an ingress resource for Celonis |
| ingress.extraHosts | list | `[]` (See [values.yaml]) | The list of additional hostnames to be covered by ingress record |
| ingress.extraPaths | list | `[]` (See [values.yaml]) | Additional ingress paths |
| ingress.extraRules | list | `[]` (See [values.yaml]) | Additional ingress rules |
| ingress.extraTls | list | `[]` (See [values.yaml]) | Additional TLS configuration |
| ingress.hostname | string | `""` | Celonis hostname |
| ingress.ingressClassName | string | `""` | Defines which ingress controller will implement the resource |
| ingress.labels | object | `{}` | Additional ingress labels |
| ingress.path | string | `"/"` | The path to Celonis |
| ingress.pathType | string | `"Prefix"` | Ingress path type. One of `Exact`, `Prefix` or `ImplementationSpecific` |
| ingress.tls.enabled | bool | `false` | Enable TLS configuration for the hostname defined at `ingress.hostname` |
| ingress.tls.selfSigned | bool | `false` | Create a Self Signed TLS Certificate for Celonis |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs)
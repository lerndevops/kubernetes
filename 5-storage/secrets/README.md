## Secrets

> A Secret is an object that contains a small amount of sensitive data such as a `password,` a `token,` or a `key`. 

> Such information might otherwise be put in a Pod specification or in a container image. 

> **`Using a Secret means that you don't need to include confidential data in your application code.`**

> Because Secrets can be created independently of the Pods that use them, there is less risk of the Secret (and its data) being exposed during the workflow of creating, viewing, and editing Pods. 

> Kubernetes, and applications that run in your cluster, can also take additional precautions with Secrets, such as avoiding writing secret data to nonvolatile storage.

### [Distribute Credentials Securely Using Secrets](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/)

### [MORE INFO](https://kubernetes.io/docs/concepts/configuration/secret/)

## data vs stringData in a secret

> You can specify the data and/or the stringData field when creating a configuration file for a Secret. The data and the stringData fields are optional. 

> The values for all keys in the data field have to be base64-encoded strings. 

> If the conversion to base64 string is not desirable, you can choose to specify the stringData field instead, which accepts arbitrary strings as values.
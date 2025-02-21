## **_pre-req:_** 
 1) **a kubernetes cluster with Sealed Secrect Controller running**
 2) **kubeseal client utility installed on a client system from which you can connect to kubernetes cluster**

## try it out:

> #### step1: create a kubernetes secret manifest with sensitive data as below

```sh
echo "kind: Secret
apiVersion: v1
metadata:
  name: mysecret
  namespace: default
data:
  username: a3ViZXJuZXRlc2hlcm8K
  password: eWVzaWFtYWt1YmVybmV0ZXNoZXJvCg==" | tee mysecret.yaml
```
> #### step2: use kubeseal to generate a sealed secret 

```sh
kubeseal -f mysecret.yaml -w my-sealed-secret.yaml
```
>>> **validate the sealed secret yaml has encrypted content**
```yaml
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: mysecret
  namespace: default
spec:
  encryptedData:
    password: AgCKtUMx5V5xkhvlBe3dZgqurkZUnapvNIfNkA5owXpDspohdb0F57K0M5em8ZBL1ypVABgm1VB9MEG5Q9ofshqj3JynIS9gbAZR3p27YoSvbltqTs1DdsOI4pBcejiJxEa9L6X4Xvrj5ofQ2GbSEEf0BpShleRsj0C0h5Iqu8b2MYU7McQZMUex0hbMWq0WIIYbqKhtIGEP7K6cYmBhwxcGGtomvSzRpioOvT3Ni7y758nBOW/qoCDFRj5gWm8V96LPrOf/+CJ3LEwpaDKadtACT/4u2bdRgZdBAuCt+4aAEbSOPC6+tcB+58LXaz23Va4SLdSiel7rRd4q6TzkKMES2WJT+YhbPVWIBP97Yub2BTJttIYgZ8qhmMwMQv1wKqsrs5v4BuipnCpXywpG/G6wVcdHRNcXupQJbUjdtmedLouhqyBUiR/aXcwI7++xWdVtSXN7qRzYqcbpXRXjATV77G8qPOCCTIpE4MDOdtP5TdK7d6HWi+FrGaOH4HekJaIh50KbvYgC7hYAynSam/6mgU/0tK+r+EEdV2NI4ycauLJ/1RKDlExeJCmiTUFz5f/5jYNKe9oLpPx6BK86uc0Bdq4AKIRnJkJUZEjiV5ToKoljwfmocxwceZuOxUeUMQD82wzLlY+fQT9Se+fQwaqsZ015n0QP1DsdBW23FDCdOEk/oHgIiovHrg56RZNJlanBcEbx/avSUCSOor8lMmn+CGpdvtRL
    username: AgAqaSM/7xFYnB9sgvqnpavfGimBQVKVOAI+VnoCW6wzRSf6xmm/3Y3tafkkjWz8sR0ygsQYKtHK4PTKmQzo6C2GRHr+oqUwBm3JLRPKtA4pQGvkiNjBPvQW43IkbHFMpM4yuHt9OV5PGyrhgWnxDCIPwn9G3D/DD7Wp53Y8WWlLUnaFQbCh1+pr4yC4rtYDnn/vP6TvxydL1m2JKU0+Xd/OtTX2LTyeKtsB+ehbVytK5WMcLTunPymC55AuiutWDbwADyGqbjAM4vd093C9h3R9hxoIAbsA+GKQtKZSnXBU9vJNromGXEOynDH7qVxIIBUoLIdOLpytgoTPvazkq/7qg5l9/RdHNsTB0hp8uFQ3d3uGJg1zMFJnWQ9hs/a0H7nhkJTpJzdqnssR/Rw+entoUb5V+TEEG5/RM2cETOLldgAA96rxBFBgPEWrKfmoWV0qEIhCafW/4Dpb9wUFHeyRyvWxifjAIM+xNaLd6j5l2JlE2Yv+Y2sAn7tPdxxY3VtDlLCYCMVHI6ycPyPb1VhKEQh7t4j3dmfK6woEzV6vCBYCQnCr0CxuJorYHnXO3NpCDiMftmImWnXbWWzyg1a3in2qYsGZ77WRqVvnloSOlvf1OOcnFMiFLdD5+AIEMB244nb9ofuiy5Bv4Ep+n5rjshwKVNLVwfh6EKWngM7Lfh5bv2Cy/Wnev9+iWAfJgXF2ZCyMLwswfIdPlNCB9Wc=
  template:
    metadata:
      creationTimestamp: null
      name: mysecret
      namespace: default
```

> #### step3: we can now push the sealsed secret yaml to git repository

> #### step4: deploy the sealed secret using kubectl / gitops tools into kubernetes cluster
```sh
kubectl apply -f my-sealed-secret.yaml
```

> #### step5: validate the secret on kubernetes cluster
```sh
lerndevops@master:~$ kubectl get secrets 
NAME                TYPE                                  DATA   AGE
mysecret            Opaque                                2      8s
```
```sh 
lerndevops@master:~$ kubectl get secret mysecret -o yaml 
apiVersion: v1
data:
  password: eWVzaWFtYWt1YmVybmV0ZXNoZXJvCg==
  username: a3ViZXJuZXRlc2hlcm8K
kind: Secret
metadata:
  creationTimestamp: "2025-02-21T06:46:12Z"
  name: mysecret
  namespace: default
  ownerReferences:
  - apiVersion: bitnami.com/v1alpha1
    controller: true
    kind: SealedSecret
    name: mysecret
    uid: 7037a957-3405-4d65-998e-52aec64be842
  resourceVersion: "2476758"
  uid: f520e3cd-5836-425c-a32c-520b2bccb20a
type: Opaque
```

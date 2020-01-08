# Kubernetes Secutiry 

## Controlling access to the Kubernetes API

> As Kubernetes is entirely API driven, controlling and limiting who can access the cluster and what actions they are allowed to perform is the first line of defense.

### Use Transport Layer Security (TLS) for all API traffic

> Kubernetes expects that all API communication in the cluster is encrypted by default with TLS, and the majority of installation methods will allow the necessary certificates to be created and distributed to the cluster components. 


### API Authentication

> Choose an authentication mechanism for the API servers to use that matches the common access patterns when you install a cluster. For instance, small single user clusters may wish to use a simple certificate or static Bearer token approach. Larger clusters may wish to integrate an existing OIDC or LDAP server that allow users to be subdivided into groups.

> All API clients must be authenticated, even those that are part of the infrastructure like nodes, proxies, the scheduler, and volume plugins. These clients are typically service accounts or use x509 client certificates, and they are created automatically at cluster startup or are setup as part of the cluster installation.

[More Info about Authentication here](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) 


### API Authorization

> Once authenticated, every API call is also expected to pass an authorization check. Kubernetes ships an integrated ***Role-Based Access Control (RBAC)*** component that matches an incoming user or group to a set of permissions bundled into roles. 

> These permissions combine verbs (get, create, delete) with resources (pods, services, nodes) and can be namespace or cluster scoped.

[More Info about Authorization here](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)


##  Understanding RBAC - Role Based Access Control

> **RBAC** is the implementation of Identity and Access Management (Authorization) in Kubernetes. RBAC uses rbac.authoriz
ation.k8s.io API to allow admins to dynamically configure policies through API server. Administrator can use RBAC api to
grant granular roles to different users or resources. A **Role** represents a set of permissions that are applied to diff
erent resources. RBAC defines 4 top-level types -

*   **Role**

      A **Role** can be used to grant access to a resource within a single namespace

*   **ClusterRole**

      A **ClusterRole** is similar to a **Role**, however, a ClusterRole extends across the cluster

*   **RoleBinding**

      A **RoleBinding** grants permission defined in a **Role** to a **User** or a **Set of Users**

*   **ClusterRoleBinding**

      A **ClusterRoleBinding** grants permission defined in a **ClusterRole** at cluster level across namespaces

##    Understanding Subjects

> A **RoleBinding** or **ClusterRoleBinding** will bind the permissions defined in a Role to ***Subjects***. A **Subject*
* is either a single user or a group of users or ServiceAccounts.  Usernames can be any custom string like "alice", "bob"
, "alice@example.com".

> Kubernetes clusters have two kinds of Users.

*     Normal Users
*     Kubernetes Managed Service Accounts

> A kubernetes managed subject has a special prefix - **system:**. Any username with the prefix **system:** is a kubernet
es managed user and is maintained & created by api server or manually through api calls. It is your administrators respon
sibility to ensure that no external user should be prefixed with **system:**. This may lead to system instability or cras
hes. The **system:** prefix can be added to either a user , group, serviceaccount, Role, ClusterRole. Few examples of kub
ernetes managed roles are -

*   system:kube-scheduler - Allows access to resources required by Scheduler
*   system:kube-controller-manager - Allows access to resources required by controller manager
*   system:kube-proxy - Allows access to the resources required by the kube-proxy

> More information about RBAC is provided at - https://kubernetes.io/docs/reference/access-authn-authz/rbac/

> While creating client certificates for kubernetes core componenets or admin user, its important to note that that inter
nal user for different components are created by Kubernetes itself. Its the certificate issuers responsibility to ensure
that the **Common Name (CN)** field is set correctly as **system:kube-\<COMPONENT_NAME\>**.

## Deafult User Facing Roles 

|***Default ClusterRole*** | ***Default ClusterRoleBinding*** | ***Description*** |
|--------------------------|-----------------------------------|-------------------|
| cluster-admin | system:masters group	| Allows super-user access to perform any action on any resource. When used in a ClusterRoleBinding, it gives full control over every resource in the cluster and in all namespaces. When used in a RoleBinding, it gives full control over every resource in the rolebinding's namespace, including the namespace itself.|
| admin | None | Allows admin access, intended to be granted within a namespace using a RoleBinding. If used in a RoleBinding, allows read/write access to most resources in a namespace, including the ability to create roles and rolebindings within the namespace. It does not allow write access to resource quota or to the namespace itself.|
| edit | None | Allows read/write access to most objects in a namespace. It does not allow viewing or modifying roles or rolebindings. |
| view | None | Allows read-only access to see most objects in a namespace. It does not allow viewing roles or rolebindings. It does not allow viewing secrets, since those are escalating. |

# Overview of SSL/TLS certificates

##  What are SSL certificates ?

> SSL certificate enables encrypted transfer of sensitive information between a client and a server. The purpose of encryption is to make sure that only the intended recipient will be able to view the information. SSL certificates are used to enable https connection between browser and websites.

##  How to generate SSL certificates ?

> There are multiple toolkits available in the market to create self signed SSL certificates. Most notable of them are - 

*  openssl
*  cfssl
*  easyrsa 

> **Self signed certificates** are useful when you want to enable SSL/TLS envryption for applications that run within your organization. These certificates are not recognized by browsers as the certificate is internal to your organization itself. In order to enable communication with any system outside your organization, you will have to set up MSSL/2 way SSL. 

> There are multiple **third party SSL certificate providers** like Verisign, Symantec, Intouch, Comodo etc. Their Certificate public key is embedded with all major browsers like chrome, IE, safari, mozilla. This enables any external user to connect to your server using a secure HTTPS connection that is recognized by the browser.  

#  Components of SSL certificate 

##  Certificate Authority (CA)

> **CA** are third party trusted entities that issues a **trusted SSL certificate**. Trusted certificate are used to create a secure connection (https) from browser/client to a server that accepts the incoming request. When you create a self-signed certificate for your organization, __**YOU**__ become the CA. 

##  Private/Public key(CSR) & Certificate

> SSL uses the concept of **private/public key pair** to authenticate, secure and manage connection between client and server. They work together to ensure TLS handshake takes place, creating a secure connection (https)

> **Private key** creates your digital signature which will eventually be trusted by any client that tries to connect to your server. With help of private key, you generate a **CSR (certificate signing request)**. Private key is kept on the server and the security of the private key is the sole responsibility of your organization. The private key should never leave your organization. 

> In contrast to private key, a **Public Key** can be distributed to multiple clients. Public Key or CSR is usually submitted to a CA like Comodo/Verisign/Entrust etc, and the CSR (formerly created by your private key) is then signed by the CA. This process generates a SSL/TLS certificate that can now be distributed to any client application. Since this certificate is signed by a trusted CA, your end users can now connect securely to your server (which contains the private key) using their browser. 

> Some third party CA also takes care of generating the private/public key pair for you. This, sometimes, is a good option in case you lose your private key or your private key is compromised. The CA provider takes care of re-keying your certificate with a new private key, and the new private key is then handed over to you. 

> When dealing with self signed certificate, its usually the organization that generates the root CA certificate and acts as the sole CA provider. Any subsequent CSR will be then signed by the root CA. This enables organizations to ensure TLS communication for applications which runs internal to them. 

##  Steps to generate a self signed certificate 

*     Choose a toolkit of your choice (openssl / easyrsa / cfssl ) -- We will use cfssl 
*     Generate root CA private key 
*     Generate a root certificate and self-sign it using the CA private key 
*     Distribute the root CA certificate on ALL the machines who wants to trust you
*     For each application/machine create a new private key 
*     Use the private key to generate a public key (CSR)
*     Ensure the Common Name Field (CN) is set accurately as per your IP address / service name or DNS
*     Sign the CSR with root CA private key and root CA certificate to generate the client certificate
*     Distribute the Client certificate to the corresponding application 

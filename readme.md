# kube-secrets
Code for a brief overview of how to create and access secrets in kubernetes.

## creating secrets and reading locally
I've created 3 secrets for the purpose of the demo:
1) dougsecret1
2) dougsecret2
3) dougsecret3
This is the most fake part of the example, because I put these secret into the repo. `Secrets Should Not Be In The Code Repo`. Our current thought is that secret value would be entered into TFS/VSTS and then during the deploy they would get read out and apply via `kubectl create secret`. 

    kubectl get secret dougs-secrets -o json
    {
        "apiVersion": "v1",
        "data": {
            "dougsecret1": "U2FudGEgaXNuJ3QgcmVhbAo=",
            "dougsecret2": "RG9uJ3QgZ2l2ZSB1cC4K",
            "dougsecret3": "SWYgaXQncyBwYXN0IHRoZSBleHBpcmF0aW9uIGRhdGUsIGRvbid0IGVhdCBpdC4KCkJlbGlldmUgbWUsIEkga25vdyB0aGlzIGlzIGEgYmFkIGlkZWEuCgpJIGRvbid0IGV2ZW4gd2FudCB0byB0ZWxsIHlvdSB0aGUgZGV0YWlscy4gRXZlbiBzZWNyZXQgcmVhZGVyIGRvbid0IHdhbnQgdG8gaGVhciBhYm91dCB0aGlzLgo="
        },
        "kind": "Secret",
        "metadata": {
            "creationTimestamp": "2018-10-11T18:11:55Z",
            "name": "dougs-secrets",
            "namespace": "drf-0918-1430",
            "resourceVersion": "8695566",
            "selfLink": "/api/v1/namespaces/drf-0918-1430/secrets/dougs-secrets",
            "uid": "22f61e13-cd81-11e8-8a1b-0a58ac1f1167"
        },
    "type": "Opaque"
    }


Note that this is showing obfuscated, not encrypted secrets. cluster-admins and other people with secret read authority in your namespace can read this data. It's pretty trivial to extract that into the actual value. The example code read-secret-locally.sh does just that.

    ./read-secret-locally.sh  1
    Santa isn't real

## reading the secret via environment variable.
In the directory environment-secret-spiller I have a trivial container that writes the value of the environment variable
 SECRET_TO_SHARE to system out. The file job.yaml shows how to tell Kubernetes you want to read a secret and pass it into
the container when it is started.

## reading the secret file filesystem
In the directory file-secret-spiller there is an trivial container that writes out the content of the file at /secret/the-secret.
The file job.yaml here shows how to tell Kubernetes you want the secret named dougs-secrets to be mounted at a directory called
/secret, and furthermore the secret named dougsecret3 should be represented in the file the-secret within that path.

It's possible to omit the items: section from the yaml, in this case each key name becomes a filename in the mount path, like this:

    # tree /secret
    /secret
    |-- dougsecret1
    |-- dougsecret2
    `-- dougsecret3


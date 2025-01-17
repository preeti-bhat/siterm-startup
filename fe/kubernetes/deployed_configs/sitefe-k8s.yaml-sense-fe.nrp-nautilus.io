apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sense-fe-vol-ense-fe-nrp-nautilus-io
  namespace: opennsa
spec:
  storageClassName: rook-ceph-block
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    kompose.cmd: kompose convert
    kompose.version: 1.21.0 (992df58d8)
  creationTimestamp: null
  labels:
    io.kompose.service: sitefe-sense-fe.nrp-nautilus.io
  name: sitefe-ense-fe-nrp-nautilus-io
spec:
  type: LoadBalancer
  ports:
  - name: "8080"
    port: 8080
    targetPort: 80
  - name: "8443"
    port: 8443
    targetPort: 443
  externalIPs:
    - 67.58.49.60
  selector:
    io.kompose.service: sitefe-sense-fe.nrp-nautilus.io
status:
  loadBalancer: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kompose.cmd: kompose convert
    kompose.version: 1.21.0 (992df58d8)
  creationTimestamp: null
  labels:
    io.kompose.service: sitefe-sense-fe.nrp-nautilus.io
  name: sitefe-sense-fe.nrp-nautilus.io
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: sitefe-sense-fe.nrp-nautilus.io
  strategy: {}
  template:
    metadata:
      annotations:
        kompose.cmd: kompose convert
        kompose.version: 1.21.0 (992df58d8)
      creationTimestamp: null
      labels:
        io.kompose.service: sitefe-sense-fe.nrp-nautilus.io
    spec:
      containers:
      - image: sdnsense/site-rm-sense:latest
        imagePullPolicy: "Always"
        name: sitefe
        resources:
          requests:
            memory: "2G"
            cpu: "1"
          limits:
            memory: "4G"
            cpu: "1"
        ports:
        - containerPort: 80
        - containerPort: 443
        volumeMounts:
        - mountPath: /opt/siterm/
          name: sense-fe-vol-ense-fe-nrp-nautilus-io
        - mountPath: /etc/dtnrm.yaml
          name: fe-conf
          subPath: sense-siterm-fe.yaml
        - mountPath: /etc/siterm-mariadb
          name: fe-environment
          readOnly: true
          subPath: environment.conf
        - mountPath: /etc/grid-security/hostcert.pem
          name: fe-hostcert
          readOnly: true
          subPath: hostcert.pem
        - mountPath: /etc/grid-security/hostkey.pem
          name: fe-hostkey
          readOnly: true
          subPath: hostkey.pem
        - mountPath: /etc/httpd/certs/cert.pem
          name: fe-httpdcert
          readOnly: true
          subPath: httpdcert.pem
        - mountPath: /etc/httpd/certs/privkey.pem
          name: fe-httpdprivkey
          readOnly: true
          subPath: httpdprivkey.pem
        - mountPath: /etc/httpd/certs/fullchain.pem
          name: fe-httpdfullchain
          readOnly: true
          subPath: httpdfullchain.pem
      nodeSelector:
          kubernetes.io/hostname: edex.calit2.optiputer.net
      restartPolicy: Always
      serviceAccountName: ""
      volumes:
      - configMap:
          defaultMode: 0644
          items:
          - key: sense-siterm-fe
            path: sense-siterm-fe.yaml
          name: sense-fe-sense-fe.nrp-nautilus.io
        name: fe-conf
      - name: fe-environment
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-environment
            path: environment.conf
          defaultMode: 0644
      - name: fe-httpdcert
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-httpdcert
            path: httpdcert.pem
          defaultMode: 0644
      - name: fe-httpdprivkey
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-httpdprivkey
            path: httpdprivkey.pem
          defaultMode: 0644
      - name: fe-httpdfullchain
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-httpdfullchain
            path: httpdfullchain.pem
          defaultMode: 0644
      - name: fe-hostcert
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-hostcert
            path: hostcert.pem
          defaultMode: 0644
      - name: fe-hostkey
        secret:
          secretName: sense-fe-sense-fe.nrp-nautilus.io
          items:
          - key: fe-hostkey
            path: hostkey.pem
          defaultMode: 0644
      - name: sense-fe-vol-ense-fe-nrp-nautilus-io
        persistentVolumeClaim:
          claimName: sense-fe-vol-ense-fe-nrp-nautilus-io
status: {}

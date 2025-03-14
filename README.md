# Terraform OpenStack Infrastructure Setup

OpenStack을 사용하여 Kubernetes 클러스터와 관련된 여러 자원을 자동으로 생성하는 Terraform 코드. 
이 코드는 네트워크, 보안 그룹, 인스턴스, 포트, 그리고 부하 분산기와 같은 여러 자원을 설정.

## 요구 사항

- Terraform 1.5 이상
- OpenStack 계정 및 인증 정보

## 제공되는 리소스

### 1. 네트워크 및 서브넷
- `demo-net`: Kubernetes 클러스터를 위한 기본 네트워크
- `demo-subnet`: `demo-net` 네트워크에 연결된 서브넷

### 2. 인스턴스 타입 (Flavor)
- `k8s_m`: Kubernetes 마스터 노드 인스턴스 타입
- `k8s_w`: Kubernetes 워커 노드 인스턴스 타입
- `k8s_lb`: Kubernetes 로드 밸런서 인스턴스 타입
- `db`: 데이터베이스 서버 인스턴스 타입
- `stg`: 스토리지 서버 인스턴스 타입
- `bastion`: 관리용 Bastion 인스턴스 타입

### 3. 보안 그룹
- `security_group`: Kubernetes 클러스터와 관련된 자원에 대한 보안 규칙을 정의하는 보안 그룹

### 4. 포트 설정
- 각 인스턴스는 고유한 내부 포트를 설정하여 네트워크 상의 연결을 정의. 예시:
  - `k8s-master1-internal-port`: Kubernetes 마스터1 포트
  - `k8s-worker1-internal-port`: Kubernetes 워커1 포트
  - `k8s-lb1-internal-port`: Kubernetes 로드 밸런서1 포트

### 5. 인스턴스 생성
여러 인스턴스가 각기 다른 역할을 수행하도록 설정:
- `bootstrap`: Ansible 서버 초기화용 인스턴스
- `master1`, `master2`, `master3`: Kubernetes 마스터 노드 인스턴스
- `worker1`, `worker2`: Kubernetes 워커 노드 인스턴스
- `lb1`, `lb2`: Kubernetes 로드 밸런서 인스턴스
- `storage`: 스토리지 서버 인스턴스
- `db1`, `db2`: 데이터베이스 서버 인스턴스
- `bastion`: Bastion 서버 (관리용)

### 6. 고정 IP 할당
- `openstack_compute_floatingip_associate_v2`: Bastion 인스턴스에 고정 IP(플로팅 IP)를 할당하여 외부에서 접속 가능하게 설정.

## 변수

- `openstack_auth_url`: OpenStack 인증 URL
- `openstack_user_name`: OpenStack 사용자 이름
- `openstack_password`: OpenStack 사용자 비밀번호
- `openstack_tenant_id`: OpenStack 테넌트 ID
- `openstack_tenant_name`: OpenStack 테넌트 이름
- `openstack_user_domain_name`: OpenStack 사용자 도메인 이름
- `openstack_region`: OpenStack 리전
- `openstack_insecure`: OpenStack SSL 인증서 검증 여부 (true/false)

## 실행 방법

1. OpenStack 인증 정보를 Terraform 변수 파일(`terraform.tfvars`)에 추가.

```hcl
openstack_auth_url = "https://your-openstack-url"
openstack_user_name = "your-username"
openstack_password = "your-password"
openstack_tenant_id = "your-tenant-id"
openstack_tenant_name = "your-tenant-name"
openstack_user_domain_name = "your-domain-name"
openstack_region = "your-region"
openstack_insecure = true

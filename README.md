# 테라폼 가이드

## Terraform을 사용하기전 종속성 패키지 자동설치
> scripts -> aws에 해당하는 OS의 스크립트 실행  `./*_running.sh`  
파일의 실행 권한이 없다면 `chmod +x *_running.sh` 실행 권한을 주고 실행  
Windows 는 <관리자 권한 실행> 필수 

## Terraform을 사용하기전 종속성 패키지 수동설치
> AWS CLI
<details><summary>windows</summary>

- Windows(64비트)용 AWS CLI MSI 설치 프로그램 다운로드 및 실행
    - https://awscli.amazonaws.com/AWSCLIV2.msi  

</details>
<details><summary>linux-ubuntu</summary>

- ```
  sudo apt-get install -y curl unzip 
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo unzip awscliv2.zip
  sudo ./aws/install
  ```
</details>

</details>
<details><summary>Mac - brew</summary>

- ```
  brew install aws
  ```
</details>

<br>

> terraaform CLI
<details><summary>windows</summary>

1. download
- 다운로드한 파일의 압축을 풀고 C:\terraform\terraform.exe에 복사합니다.
  - https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_windows_386.zip  

2. 환경변수 등록.
- 관리자 권한으로 Powershell을 실행하여 아래 명령어를 실행.
  - `[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\terraform", "Machine")`

</details>
<details><summary>linux-ubuntu</summary>

- ```
  sudo apt-get install -y wget
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
   ```
</details>
<details><summary>Mac - brew</summary>

- ```
  brew install terraform
   ```
</details>

<details><summary>Mac - brew(Silicon)</summary>

- ```
  brew install terraform
  git clone https://github.com/hashicorp/terraform-provider-template

  cd terraform-provider-template

  go build

  mkdir -p  ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64

  mv terraform-provider-template ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5
  
  chmod +x ~/.terraform.d/plugins/registry.terraform.io/hashicorp/template/2.2.0/darwin_arm64/terraform-provider-template_v2.2.0_x5
   ```
</details>
<br>
<br>

## 변수 및 config 세팅 <필수>
<details><summary>IAM 계정정보 및 도메인 수정 </summary>

 >terraform/main/*.tfvars  
 workspace를 따로 생성하지 않으면 기본적으로 defaul.tfvars에 설정  
 workspace 생성시 workspace네임에 맞도록 tfvars 파일을 구성하고 내용을 수정  
 현재 workspace 확인 방법 `terraform workspace show`  
 예) workspace가 dev일 시  
 dev.tfvars 
```
  // ssh-key name
  // aws 콘솔 ec2 -> 키페어 생성 뒤 설정 
  default_Key = "Key name"

  // route53 host name
  // 콘솔 acm 목록에 존재 
  host_name = "test.com"
  host_pattern = "*.test.com"
  ACCOUNT_ID = 112233445566
  availability_zones = "ap-northeast-2"

  // domain 
  // ec2에 Omnibus gitlab 및 nexus 설치시 설정 (미설치시 설정없이 진행)
  gitlab_domain_name = "gitlab.test.com"
  nexus_domain_name = "nexus.test.com"
  reg_domain_name = "reg.test.com"

  //backend name
  backend_bucket = "S3-bucket-name"
  backend_dynamodb = "dynamodb-table"
```
</details>
<details><summary>Backend config 수정</summary>

 >terraform/main/backend.conf

```
  //backend S3 bucket name
  bucket = "S3-bucket-name"

  //backend dynamodb table
  dynamodb_table = "dynamodb-table"
```
</details>
<br>


## Terraform 실행 (처음 세팅이 아닐 경우 3번부터 시작)

### 1. AWS 자격 증명 구성
- ```
  aws configure
  AWS Access Key ID [None]:                     # IAM Access Key 
  AWS Secret Access Key [None]:                 # IAM Secret Access Key 
  Default region name [None]: ap-northeast-2    # region  
  Default output format [None]: json            # json
  ```

  
### 2. 백엔드 구성


- <details>
  <summary>S3를 이용한 백엔드 구성</summary>

  > terraform 에서 backend란 terraform의 상태 데이터를 저장 하고 실행환경을 제공 하는 컴포넌트 입니다\
  상태 데이터는 tfstate 파일에 저장 되며 상태파일 저장소로 S3 버킷을 사용 하고 있습니다\
  이 프로젝트에선 remote state를 통해 S3에 저장 되어 있는 tfstate 파일의 리소스를 사용하고 있어\
  필수로 진행해야 하는 구성 입니다. backend에는 다음과 같은 항목이 생성 됩니다
  > - S3 bucket
  > - DynamoDB_table

  <br>

  - 터미널에서 main->dependency->backend 위치로 이동
    - ``` 
      terraform> cd .\main\dependency\backend\
      terraform\main\dependency\backend> 
      ``` 
  
  - main.tf 41-49 블럭을 주석처리 합니다
    - ```
      ### 41 line.
  
      # terraform {
      # backend "s3" {
      #     key            = "main/dependency/backend/terraform.tfstate"
      #     region         = "ap-northeast-2"
      #     encrypt        = true
      #   }
      # }
      ```
  - `terraform init`으로 aws provider 구성
    - ```
      terraform\main\dependency\backend> terraform init -backend-config="../../backend.conf"
   
      ...
  
      Terraform has been successfully initialized!
  
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
  
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\dependency\backend>
      ```
  - Workspace 구성
    - ```
      terraform\main\dependency\backend> terraform workspace show 
      default
      terraform\main\dependency\backend> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\dependency\backend> terraform workspace show    
      test
      terraform\main\dependency\backend>    
      ```
  - `terraform apply` 후 `Enter a value` 에서 yes 입력 (S3와 synamodb 생성)
  
    - ```
      terraform\main\dependency\backend> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Do you want to perform these actions in workspace "test"?
        Terraform will perform the actions described above.
        Only 'yes' will be accepted to approve.
      
        Enter a value: yes       
      ...
      
      
      Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
      terraform\main\dependency\backend>
      ```
  
  - `main.tf` 41~49 블럭 주석 해제
    - ```
      ### 41. line
      
      terraform {
        backend "s3" {
          key            = "main/dependency/backend/terraform.tfstate"
          region         = "ap-northeast-2"
          encrypt        = true
        }
      }  
      ```
  - `terraform init` 실행 후 `Enter a value` 에서 yes 입력
    - ```
      terraform\main\dependency\backend> terraform init -backend-config="../../backend.conf"
      Initializing the backend...
      Do you want to migrate all workspaces to "s3"?
      Both the existing "local" backend and the newly configured "s3" backend
      support workspaces. When migrating between backends, Terraform will copy
      all workspaces (with the same names). THIS WILL OVERWRITE any conflicting
      states in the destination.
  
      Terraform initialization doesn't currently migrate only select workspaces.
      If you want to migrate a select number of workspaces, you must manually
      pull and push those states.
  
      If you answer "yes", Terraform will migrate all states. If you answer
      "no", Terraform will abort.
  
      Enter a value: yes 
      
      ...
      
      
      Terraform has been successfully initialized!
  
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.    
      ```
  - `terraform apply` 실행
    - ```
      terraform\main\dependency\backend> terraform apply -var-file="../../global.tfvars"
      ...
      Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
      ```

### 3. Provision 구성
- <details>
  <summary>1. resources 생성</summary>

  > terraform 프로비저닝 단계에서 dependency/resource 에서 생성 한 리소스를 사용하여\
  다른 인스턴스를 생성 하기 때문에 dependency/resource를 가장 먼저 생성 해야 합니다\
  dependency/resource에는 다음과 같은 항목이 생성 됩니다
  > - vpc (subnet , gateway , route table , eip 등) 
  > - securitygroup 
  > - storage (s3,efs) 
  > - iam

  <br>
  
  - 터미널에서 `main\dependent\resources` 위치로 이동합니다.
    - ``` 
      terraform\main\dependency\backend> cd ..\dependency\resources\
      terraform\main\dependency\resources> 
      ```
  
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\dependency\resources> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\dependency\resources>
      ```
  - Workspace 구성
    - ```
      terraform\main\dependency\resources> terraform workspace show 
      default
      terraform\main\dependency\resources> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\dependency\resources> terraform workspace show    
      test
      terraform\main\dependency\resources>  
      ```
  - `terraform apply` 로 resource 생성 ( `Enter a value` 에서 yes 입력)
    - ```
      terraform\main\dependency\resources> terraform apply -var-file="../../global.tfvars"
      Do you want to perform these actions in workspace "test"?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.
         Enter a value: yes 
      
      ...
      
      Apply complete! 
      terraform\main\dependency\resources>  
      ```
  
  
  > terraform\main\dependency\resources\ 경로에\
  bastion_readme.md 파일에 bastion host 접속 정보가 있습니다   
  </details>

- <details>
  <summary>2. EC2-bastionhost 생성</summary>

  >bastionhost는 dependency/resource가 생성된 후 생성해야 합니다\
  locals를 적절히 변경하여 생성하여야 합니다\
  bastion_host에서 ssh를 통해 gitlab 과 nexus에 접근할 수 있습니다\
  apply를 하게되면 bastion_host_readme.md 가 생성 되는데 여기엔 bastion_host의 접속 ip와\
  bastion_host 에서 gitlab 혹은 nexus의 연결을 위한 ssh명령어가 표기 되어 있습니다
  
  <br>
  
  - 터미널에서 `main\instance\bastion` 위치로 이동
    - ``` 
      terraform\main\instance\bastion>
      ```
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\instance\bastion> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\instance\bastion>
      ```
  - Workspace 구성
    - ```
      terraform\main\instance\bastion> terraform workspace show 
      default
      terraform\main\instance\bastion> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\instance\bastion> terraform workspace show    
      test
      terraform\main\instance\bastion>
      ```
  - `terraform apply -var-file="../../global.tfvars"` 로 bastion 생성 ( `Enter a value` 에서 yes   입력)
    - ```
      terraform\main\instance\bastion> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Apply complete!
      terraform\main\instance\bastion> 
      ```
  </details>

- <details>
  <summary>3. EC2-nexus 생성</summary>

  > nexus는 dependency/resource가 생성된 후 생성해야 합니다\
  locals를 적절히 변경하여 생성하여야 합니다
  <br>

  - 터미널에서 `main\instance\nexus` 위치로 이동
    - ``` 
      terraform\main\instance\nexus>
      ```
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\instance\nexus> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\instance\nexus>
      ```
  - Workspace 구성
    - ```
      terraform\main\instance\nexus> terraform workspace show 
      default
      terraform\main\instance\nexus> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\instance\nexus> terraform workspace show    
      test
      terraform\main\instance\nexus>
      ```
  - `terraform apply -var-file="../../global.tfvars"` 로 nexus 생성 ( `Enter a value` 에서 yes 입력)
    - ```
      terraform\main\instance\nexus> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Apply complete! 
      terraform\main\instance\nexus> 
      ```
  </details>

 
- <details>
  <summary>4. eks cluster 생성</summary>

  > eks는 dependency/resource가 생성된 후 생성해야 합니다\
  locals를 적절히 변경하여 생성하여야 합니다\
  apply 시 해당 경로에 readme 파일이 생성되며 cluster에 연결할 수 있는 awscli 명령어가 표기되어\
  있습니다 eks 구성시 default로 여러 패키지가 한번에 설치 되는데 설치되는 목록은 아래와 같습니다
  > - ALB ingress Controller  
  > - Metrics Server
  > - External DNS 
  > - EBS CSI Driver
  > - EFS CSI Driver
  > - Nginx ingress Controller

  <br>  
  
  - 터미널에서 `main\instance\eks` 위치로 이동
    - ``` 
      terraform\main\instance\eks>
      ```
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\instance\eks> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\instance\eks>
      ```
  - Workspace 구성
    - ```
      terraform\main\instance\eks> terraform workspace show 
      default
      terraform\main\instance\eks> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\instance\eks> terraform workspace show    
      test
      terraform\main\instance\eks>
      ```
  - `terraform apply -var-file="../../global.tfvars"` 로 eks 생성 ( `Enter a value` 에서 yes 입력)
    - ```
      terraform\main\instance\eks> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Apply complete! 
      terraform\main\instance\eks> 
      ```
  
  </details>


- <details>
  <summary>5. RDS 생성</summary> 

  > rds는 dependency/resource가 생성 된 후 생성해야 합니다\
  global.tfvars 에서 instance type을 지정 할 수 있으며 locals 를 적절히 변경 하여 생성 하여야 합니다\
  apply시에는 해당경로에 readme 파일이 생성되며 rds 접속 주소와 포트 번호가 표기 되어 있습니다
  <br>

  
  - 터미널에서 `main\rds\postgressql` 위치로 이동
    - ``` 
      terraform\main\rds\postgressql>
      ```
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\rds\postgressql> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\rds\postgressql>
      ```
  - Workspace 구성
    - ```
      terraform\main\rds\postgressql> terraform workspace show 
      default
      terraform\main\rds\postgressql> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\rds\postgressql> terraform workspace show    
      test
      terraform\main\rds\postgressql>
      ```
  - `terraform apply -var-file="../../global.tfvars"` 로 postgressql 생성 ( `Enter a value` 에서   yes 입력)
    - ```
      terraform\main\rds\postgressql> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Apply complete! 
      terraform\main\rds\postgressql> 
      ```
  
  </details>


- <details>
  <summary>6. alert 생성</summary> 

  > alert는 dependency/resource가 생성된 후 생성해야 합니다\
  locals를 적절히 변경하여 생성하여야 합니다\
  apply 시에는 해당 경로에 readme 파일이 생성되며 smtp 계정의 access_key와 secret_key가\
  표기되어 있습니다. 해당 key 정보들은 portal installer 쪽에서 필요한 정보입니다\
  인프라 구성이 끝난 후 portal installer 쪽에 key 정보를 넘겨주어야 하며 넘겨준 뒤에는\
  해당 readme 파일은 보안을 위해 삭제하여야 합니다\
  alert에는 다음과 같은 항목이 생성됩니다  
  > - iam 계정 (smtp sns) 
  > - ses
  > - sns (sns_topic)

  <br>

  
  - 터미널에서 `main\etc\alert` 위치로 이동
    - ``` 
      terraform\main\etc\alert>
      ```
  - `terraform init` AWS provider 구성
    - ```
      terraform\main\etc\alert> terraform init -backend-config="../../backend.conf"
      
      ...
      
      Terraform has been successfully initialized!
      
      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.
      
      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      terraform\main\etc\alert>
      ```
  - Workspace 구성
    - ```
      terraform\main\etc\alert> terraform workspace show 
      default
      terraform\main\etc\alert> terraform workspace new test
      Created and switched to workspace "test"!
      
      You're now on a new, empty workspace. Workspaces isolate their state,
      so if you run "terraform plan" Terraform will not see any existing state
      for this configuration.
      terraform\main\etc\alert> terraform workspace show    
      test
      terraform\main\etc\alert>
      ```
  - `terraform apply -var-file="../../global.tfvars"` 로 alert 생성 ( `Enter a value` 에서 yes 입력)
    - ```
      terraform\main\etc\alert> terraform apply -var-file="../../global.tfvars"
      
      ...
      
      Apply complete! 
      terraform\main\etc\alert> 
      ```
      
  </details>




provider "oci" {
  tenancy_ocid = "Root compartment OCID"
  user_ocid = "OCID del usuario"
  private_key_path = "/home/oracle/.oci/oci_api_key.pem"
  fingerprint = "Lo podemos encontrar dentro de la configuracion de usuario"
  region = "eu-frankfurt-1"
}

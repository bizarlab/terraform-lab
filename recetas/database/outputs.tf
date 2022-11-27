# Outputs for compute instance

output "private_ip" {
  value = oci_core_instance.oracle_linux_instance.private_ip
}
output "instance-name" {
  value = oci_core_instance.oracle_linux_instance.display_name
}

output "instance-OCID" {
  value = oci_core_instance.oracle_linux_instance.id
}

output "instance-region" {
  value = oci_core_instance.oracle_linux_instance.region
}

output "instance-shape" {
  value = oci_core_instance.oracle_linux_instance.shape
}

output "instance-state" {
  value = oci_core_instance.oracle_linux_instance.state
}

output "instance-OCPUs" {
  value = oci_core_instance.oracle_linux_instance.shape_config[0].ocpus
}

output "instance-memory-in-GBs" {
  value = oci_core_instance.oracle_linux_instance.shape_config[0].memory_in_gbs
}

output "time-created" {
  value = oci_core_instance.oracle_linux_instance.time_created
}
output "iqn" {
  value = oci_core_volume_attachment.CreateVolumeAttachment.iqn
}
output "port" {
  value = oci_core_volume_attachment.CreateVolumeAttachment.port
}

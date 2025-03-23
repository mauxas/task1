resource "helm_release" "main" {
  for_each = var.helm_releases

  name       = each.value.name
  chart      = each.value.chart_path
  namespace  = each.value.namespace
  values = [
    "${file(each.value.values_file)}"
  ]
}

resource "helm_release" "tests" {
  for_each = var.helm_releases_tests

  name       = each.value.name
  chart      = each.value.chart_path
  namespace  = each.value.namespace
  values = [
    "${file(each.value.values_file)}"
  ]
  depends_on = [ helm_release.main ]
}
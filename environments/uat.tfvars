project = "hrs"
environment = "uat"
api_image = "feri10224/hrs-api:uat-latest"
common_tags = {
  env = "uat"
}
application_insights_profilerfeature_version = "1.0.0"
application_insights_snapshotfeature_version = "1.0.0"
application_insights_configuration_content = ""
application_insights_agent_extension_version = "~3"
diagnostic_services_extension_version = "~3"
instrumentation_engine_extension_version = "disabled"
snapshot_debugger_extension_version = "disabled"
xdt_microsoft_application_insights_base_extensions = "disabled"
xdt_microsoft_application_insights_mode = "recommended"
xdt_microsoft_application_insights_preempt_sdk = "disabled"
app_setting_names = [
  "APPINSIGHTS_INSTRUMENTATIONKEY",
  "APPINSIGHTS_PROFILERFEATURE_VERSION",
  "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
  "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
  "ApplicationInsightsAgent_EXTENSION_VERSION",
  "DiagnosticServices_EXTENSION_VERSION",
  "InstrumentationEngine_EXTENSION_VERSION",
  "SnapshotDebugger_EXTENSION_VERSION",
  "XDT_MicrosoftApplicationInsights_BaseExtensions",
  "XDT_MicrosoftApplicationInsights_Mode",
  "XDT_MicrosoftApplicationInsights_PreemptSdk",
  "APPLICATIONINSIGHTS_CONNECTION_STRING",
  "XDT_MicrosoftApplicationInsightsJava",
  "XDT_MicrosoftApplicationInsights_NodeJS"
]
connection_string_names = ["ConnectionStrings__DefaultConnection", "APPLICATIONINSIGHTS_CONNECTION_STRING"]
publisher_name = "HRS UAT"
publisher_email = "e1546606@u.nus.edu"
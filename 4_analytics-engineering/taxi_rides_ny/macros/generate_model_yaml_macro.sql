{% macro generate_model_yaml_macro() %}

  {% set models_to_generate = [
      'stg_green_tripdata',
      'stg_yellow_tripdata'
  ] %}

  {{ log("Found models: " ~ models_to_generate | join(", "), info=True) }}

  {{ codegen.generate_model_yaml(
      model_names = models_to_generate
  ) }}

{% endmacro %}

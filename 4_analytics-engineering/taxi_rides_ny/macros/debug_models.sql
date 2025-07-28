{% macro debug_models() %}
  {% for model in graph.nodes.values() %}
    {{ log(model.path, info=True) }}
  {% endfor %}
{% endmacro %}

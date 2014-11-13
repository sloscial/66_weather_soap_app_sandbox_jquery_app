null
###*
@class AP.view.Field
@extends AP.view.View

A generic HTML form field.

Field types supported:
* checkbox
* textarea
* boolean yes/no select
* text, email, etc (all others are treated as `input`)
###
class AP.view.Field extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-field'
  
  ###*
  @property {String}
  Field name.
  ###
  name: ''
  
  ###*
  @property {String}
  Field label.
  ###
  label: ''
  
  ###*
  @property {String}
  Field type.  See main article for list of supported types.
  ###
  type: 'text'
  
  ###*
  @property {String}
  Default value.
  ###
  value: ''
  
  ###*
  @property {String}
  Placeholder text.
  ###
  placeholder: ''
  
  ###*
  @property {Boolean}
  If this is a checkbox field, is it checked by default?
  ###
  checked: false
  
  ###*
  @property {Boolean}
  Is the field disabled?
  ###
  disabled: false
  
  ###*
  @property {Boolean}
  Is the field required?
  ###
  required: false
  
  ###*
  @property {Object}
  Key/value hash of attribute names and values to add to this view's element.
  ###
  attributes: {}
  
  ###*
  @property {Object}
  Key/value hash of attribute names and values to add to this field
  element itself.
  ###
  inputAttributes: null
  
  ###*
  @property {String}
  An HTML form field template.
  ###
  template: '''
    {% if (type != 'hidden') { %}
      {% if (label && (type !== 'checkbox')) { %}
        <label for="{%- name %}">{%- label %}:</label>
      {% } %}
      {% if (type === 'textarea') { %}
        <textarea {% if (required) { %}required{% } %} name="{%- name %}" value="{%- value %}" {% if (placeholder) { %}placeholder="{%- placeholder %}"{% } %}{% if (disabled) { %} disabled="disabled"{% } %}{% if (inputAttributes) { %}{% for (attr in inputAttributes) { %} {{ attr }}="{{ inputAttributes[attr] }}"{% } %}{% } %}></textarea>
      {% } else if (type === 'toggle') { %}
        <select {% if (required) { %}required{% } %} name="{%- name %}" data-role="slider"{% if (disabled) { %} disabled="disabled"{% } %}>
        	<option value="false">Off</option>
        	<option value="true"{% if (checked) { %} selected{% } %}>On</option>
        </select>
      {% } else if (type === 'checkbox') { %}
        <input {% if (required) { %}required{% } %} type="{%- type %}" name="{%- name %}" id="{%- name %}" {% if (checked) { %}checked="checked"{% } %}{% if (disabled) { %} disabled="disabled"{% } %} {% for (attr in inputAttributes) { %} {{ attr }}="{{ inputAttributes[attr] }}"{% } %} />
        {% if (label) { %}
          <label for="{%- name %}">{%- label %}</label>
        {% } %}
      {% } else { %}
        <input {% if (required) { %}required{% } %} type="{%- type %}" name="{%- name %}" value="{%- value %}" {% if (placeholder) { %}placeholder="{%- placeholder %}"{% } %}{% if (disabled) { %} disabled="disabled"{% } %} {% for (attr in inputAttributes) { %} {{ attr }}="{{ inputAttributes[attr] }}"{% } %} />
      {% } %}
    {% } else { %}
      <input {% if (required) { %}required{% } %} type="{%- type %}" name="{%- name %}" value="{%- value %}" {% for (attr in inputAttributes) { %} {{ attr }}="{{ inputAttributes[attr] }}"{% } %} />
    {% } %}
  '''

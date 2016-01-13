class HtmlWrapper {
  constructor(rootElement) {
    this.$root = $(rootElement);
  } // end constructor
} // end class

class FormField extends HtmlWrapper {
  constructor(rootElement) {
    super(rootElement);

    this.qualifiedPropertyName = this.$root.data('formGroupName');

    let segments      = this.qualifiedPropertyName.replace(']', '').split('[');
    this.propertyName = segments[segments.length - 1];
    this.$input       = this.$root.find(`[name="${this.qualifiedPropertyName}"]`);
  } // end constructor

  get value() {
    return this.$input.val();
  } // end accessor value
} // end class

class ContactForm extends HtmlWrapper {
  constructor(rootElement) {
    super(rootElement);

    this._buildFields();

    this.$root.submit(this.formSubmittedHandler());
  } // end constructor

  get data() {
    let propertyName;
    let field;
    let values = {};

    for(propertyName in this.fields) {
      field = this.fields[propertyName];

      values[propertyName] = field.value;
    } // end for

    return values;
  } // end accessor data

  get url() {
    return this.$root.prop('action');
  } // end accessor url

  // Event Handlers

  formSubmittedHandler() {
    let form = this;

    return function(event) {
      event.preventDefault();

      let request = window.request = jQuery.post(form.url, { "contact": form.data });

      request.done(data => {
        console.log('request done!');
        console.log(data);
      });

      request.fail(form.formSubmitFailure);
    }; // end handler
  } // end method formSubmittedHandler

  formSubmitFailure(request) {
    console.log('request fail!');
    console.log(request);
    console.log(request.responseJSON);
  } // end handler formSubmitFailure

  // Private Methods

  _buildFields() {
    this.fields = {};

    let form = this;

    this.$root.children('.form-group').each(function(index) {
      let formField = new FormField($(this));

      form.fields[formField.propertyName] = formField;
    }); // end each
  } // end method _buildFields
} // end class

jQuery(document).ready(event => {
  let form = window.form = new ContactForm($('form#new_contact'));

  console.log('Greetings, programs!');
}); // end ready handler

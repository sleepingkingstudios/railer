'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var HtmlWrapper = function HtmlWrapper(rootElement) {
  _classCallCheck(this, HtmlWrapper);

  this.$root = $(rootElement);
} // end constructor
; // end class

var FormField = function (_HtmlWrapper) {
  _inherits(FormField, _HtmlWrapper);

  function FormField(rootElement) {
    _classCallCheck(this, FormField);

    var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(FormField).call(this, rootElement));

    _this.qualifiedPropertyName = _this.$root.data('formGroupName');

    var segments = _this.qualifiedPropertyName.replace(']', '').split('[');
    _this.propertyName = segments[segments.length - 1];
    _this.$input = _this.$root.find('[name="' + _this.qualifiedPropertyName + '"]');
    return _this;
  } // end constructor

  _createClass(FormField, [{
    key: 'value',
    get: function get() {
      return this.$input.val();
    } // end accessor value

  }]);

  return FormField;
}(HtmlWrapper); // end class

var ContactForm = function (_HtmlWrapper2) {
  _inherits(ContactForm, _HtmlWrapper2);

  function ContactForm(rootElement) {
    _classCallCheck(this, ContactForm);

    var _this2 = _possibleConstructorReturn(this, Object.getPrototypeOf(ContactForm).call(this, rootElement));

    _this2._buildFields();

    _this2.$root.submit(_this2.formSubmittedHandler());
    return _this2;
  } // end constructor

  _createClass(ContactForm, [{
    key: 'formSubmittedHandler',
    // end accessor url

    // Event Handlers

    value: function formSubmittedHandler() {
      var form = this;

      return function (event) {
        event.preventDefault();

        var request = window.request = jQuery.post(form.url, { "contact": form.data });

        request.done(function (data) {
          console.log('request done!');
          console.log(data);
        });

        request.fail(form.formSubmitFailure);
      }; // end handler
    } // end method formSubmittedHandler

  }, {
    key: 'formSubmitFailure',
    value: function formSubmitFailure(request) {
      console.log('request fail!');
      console.log(request);
      console.log(request.responseJSON);
    } // end handler formSubmitFailure

    // Private Methods

  }, {
    key: '_buildFields',
    value: function _buildFields() {
      this.fields = {};

      var form = this;

      this.$root.children('.form-group').each(function (index) {
        var formField = new FormField($(this));

        form.fields[formField.propertyName] = formField;
      }); // end each
    } // end method _buildFields

  }, {
    key: 'data',
    get: function get() {
      var propertyName = undefined;
      var field = undefined;
      var values = {};

      for (propertyName in this.fields) {
        field = this.fields[propertyName];

        values[propertyName] = field.value;
      } // end for

      return values;
    } // end accessor data

  }, {
    key: 'url',
    get: function get() {
      return this.$root.prop('action');
    }
  }]);

  return ContactForm;
}(HtmlWrapper); // end class

jQuery(document).ready(function (event) {
  var form = window.form = new ContactForm($('form#new_contact'));

  console.log('Greetings, programs!');
}); // end ready handler
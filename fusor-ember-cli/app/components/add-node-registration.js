import Ember from 'ember';
import OspNodeForm from '../mixins/osp-node-form-mixin';

export default Ember.Component.extend(OspNodeForm, {
  isNewNodeMethodManual: true,
  resetErrorsMessageKey: 'add-node-registration.text-f:resetErrors',

  addNodeTitle: Ember.computed('nodeInfo.address', function() {
    return "Add Node(s) to " + this.get('nodeInfo.address');
  }),

  nodeDriverHumanized: Ember.computed('nodeInfo.driver', function () {
    let driver = this.get('drivers').findBy('value', this.get('nodeInfo.driver'));
    if (driver) {
      return driver.label;
    }
  }),

  disableNewNodesSubmit: Ember.computed.not('isValidNewNodeManual'),

  onOpenModal: Ember.observer('openModal', function() {
    if (this.get('openModal')) {
      Ember.run.once(this, 'initInfo');
    }
  }),

  actions: {
    cancelAddNodes() {
      this.set('openModal', false);
    },
    submitAddNodes() {
      this.prepManualNodeInfo();
      this.sendAction('submitAddNodes', this.get('nodeInfo'));
      this.set('openModal', false);
    }
  },

  initInfo() {
    this.eventBus.trigger(this.get('resetErrorsMessageKey'));
    this.set('manualMacAddresses', '');
  }
});

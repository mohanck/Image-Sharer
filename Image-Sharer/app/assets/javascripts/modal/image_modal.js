import $ from 'jquery';

export default class ImageModal {
  constructor(modal) {
    this.$modal = $(modal)
  }

  closeModal() {
    $('.js-modal').modal('hide');
    $('.modal-backdrop').remove();
  }

  closeModalAndDisplayFlash(obj) {
    this.closeModal();
    this.displayFlash(obj);
  }

  displayFlash(obj) {
    const key = Object.keys(obj)[0];
    $('div.text-muted.text-center').replaceWith(`<div class='text-muted text-center'><div class='alert alert-${key}'>${obj[key]}</div></div>`);
  }

  attachEventHandlers() {
    this.$modal.on('show.bs.modal', event => {
      const modalTrigger = event.relatedTarget;
      const imageId = modalTrigger.dataset.imageId;

      $.ajax({
        url: `/images/${imageId}/share`,
        type: 'GET',
        success: (data) => {
          this.$modal.find('.modal-body').html(data);
        },
        error: (jqXHR) => {
          if(jqXHR.status === 404) { //Image does not exist - Share
            this.closeModalAndDisplayFlash(jqXHR.responseJSON.flash);
          }
        }
      });
    });

    this.$modal.on('ajax:error', (jqXHR, textStatus) => {
      if(textStatus.status === 422) { //Form Validation Error
        this.$modal.find('.js-modal-body').html(textStatus.responseText);
      }
      else if(textStatus.status === 404) { //Image does not exist - Send Email
        if ($('.js-modal').is(':visible') && textStatus.responseJSON.flash) {
          this.closeModalAndDisplayFlash(textStatus.responseJSON.flash);
        }
      }
    });

    this.$modal.on('ajax:success', (event, data) => {
      if ($('.js-modal').is(':visible') && data.flash) {
        this.closeModalAndDisplayFlash(data.flash);
      }
    });
  }
}

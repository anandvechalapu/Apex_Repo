import { LightningElement, track } from 'lwc';

export default class WelcomeModal extends LightningElement {
    @track modalOpen;

    handleClick(){
        this.modalOpen = true;
    }

    handleClose(){
        this.modalOpen = false;
    }

    handleClickOutside(){
        this.modalOpen = false;
    }

}
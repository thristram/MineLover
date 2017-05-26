func showPorgress(progress: Int){
    switch(progress){
        case 1:
            cell.storeElementProgress_1.isHidden = false;
            cell.storeElementProgress_2.isHidden = true;
            cell.storeElementProgress_3.isHidden = true;
            cell.storeElementProgress_4.isHidden = true;
            cell.storeElementProgress_5.isHidden = true;
            break;

        case 2:
            cell.storeElementProgress_1.isHidden = false;
            cell.storeElementProgress_2.isHidden = false;
            cell.storeElementProgress_3.isHidden = true;
            cell.storeElementProgress_4.isHidden = true;
            cell.storeElementProgress_5.isHidden = true;
            break;
        case 3:
            cell.storeElementProgress_1.isHidden = false;
            cell.storeElementProgress_2.isHidden = false;
            cell.storeElementProgress_3.isHidden = false;
            cell.storeElementProgress_4.isHidden = true;
            cell.storeElementProgress_5.isHidden = true;
            break;
        case 4:
            cell.storeElementProgress_1.isHidden = false;
            cell.storeElementProgress_2.isHidden = false;
            cell.storeElementProgress_3.isHidden = false;
            cell.storeElementProgress_4.isHidden = false;
            cell.storeElementProgress_5.isHidden = true;
            break;
        case 5:
            cell.storeElementProgress_1.isHidden = false;
            cell.storeElementProgress_2.isHidden = false;
            cell.storeElementProgress_3.isHidden = false;
            cell.storeElementProgress_4.isHidden = false;
            cell.storeElementProgress_5.isHidden = false;
            break;
        default:
            cell.storeElementProgress_1.isHidden = true;
            cell.storeElementProgress_2.isHidden = true;
            cell.storeElementProgress_3.isHidden = true;
            cell.storeElementProgress_4.isHidden = true;
            cell.storeElementProgress_5.isHidden = true;
            break;

    }
}

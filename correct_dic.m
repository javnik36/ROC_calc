function correct_dic(ncorr_save)
%%%calculates corrected data using ROC algorithms and applies it to every
%%%v and u data from NCORR save for *reference* type of data only
%%%prerequisites: ROI region inside of ROC region (2 regions only)
%%%WARNING! SAVES IN PLACE! BACKUP YOUR NCORR DATA!
%%%input:
%%%ncorr_save - abs path of ncorr save
%%%outputs:
%%%2 NCORR saves: 1 with corrected ROI&ROC data and 1 with only ROI
%%%corrected and ROC 0'ed
    load(ncorr_save);
    roi_only=data_dic_save.displacements;
    %loop for displacements
    for i=1:size(data_dic_save.displacements,2)
        regions_struct = data_dic_save.displacements(i).roi_ref_formatted.data.region;
        %warning! only 2 regions
        %find bboxes of roi and roc
        if regions_struct(1).leftbound < regions_struct(2).leftbound
            %regions_struct(1) == ROC
            %regions_struct(2) == ROI
            data_bbox = [regions_struct(1).leftbound+1 regions_struct(1).rightbound+1 regions_struct(1).upperbound+1 regions_struct(1).lowerbound+1; ...
                regions_struct(2).leftbound+1 regions_struct(2).rightbound+1 regions_struct(2).upperbound+1 regions_struct(2).lowerbound+1];
        else
            data_bbox = [regions_struct(2).leftbound+1 regions_struct(2).rightbound+1 regions_struct(2).upperbound+1 regions_struct(2).lowerbound+1; ...
                regions_struct(1).leftbound+1 regions_struct(1).rightbound+1 regions_struct(1).upperbound+1 regions_struct(1).lowerbound+1];
        end
        %separate roi and roc data from image
        u_data=data_dic_save.displacements(i).plot_u_ref_formatted;
        u_roc=u_data;
        u_roc(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=0;
        u_roi=u_data(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2));
        
        v_data=data_dic_save.displacements(i).plot_v_ref_formatted;
        v_roc=v_data;
        v_roc(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=0;
        v_roi=v_data(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2));
        %calculation of corrected data
        [u_corrected,v_corrected,u_corrected_roc,v_corrected_roc]=roc_calc(u_roc,v_roc,u_roi,v_roi);
        %replacing original ncorr data with corrected from calculation
        data_dic_save.displacements(i).plot_v_ref_formatted=v_corrected_roc;
        data_dic_save.displacements(i).plot_v_ref_formatted(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=v_corrected;
        data_dic_save.displacements(i).plot_u_ref_formatted=u_corrected_roc;
        data_dic_save.displacements(i).plot_u_ref_formatted(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=u_corrected;
        roi_only(i).plot_v_ref_formatted(:,:)=0;
        roi_only(i).plot_v_ref_formatted(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=v_corrected;
        roi_only(i).plot_u_ref_formatted(:,:)=0;
        roi_only(i).plot_u_ref_formatted(data_bbox(2,3):data_bbox(2,4),data_bbox(2,1):data_bbox(2,2))=u_corrected;
        
    end
    save(ncorr_save,'current_save','data_dic_save','reference_save');
    data_dic_save.displacements=roi_only;
    save('ROC_zeroed.mat','current_save','data_dic_save','reference_save');
end
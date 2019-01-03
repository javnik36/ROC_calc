function [u_corrected,v_corrected,u_corrected_roc,v_corrected_roc]=roc_calc(u_roc,v_roc,u_roi,v_roi)
%%%calculates corrected regions using ROC data
%%%inputs:
%%%u,v_roc - u and v data for ROC region
%%%u,v_roi - u and v data for ROI region
%%%outputs:
%%%u,v_corrected - u and v data with correct values (for roi only)
%%%u,v_corrected_roc - u and v ROC data corrected using same algorithm
%%%(ROC corrected by ROC)
    X_C=[];
    Y_C=[];
    Y_prim_C=[];
    k=1;
    b=v_roc;
    c=u_roc;
    %b - macierz v, c - macierz u 
    for i=1:size(b,1) %1-rows(y) 2-columns(x)
        for j=1:size(b,2)
            if ~ b(i,j)==0
                X_C(k,1)=1;
                X_C(k,2)=j;
                X_C(k,3)=i;
                X_C(k,4)=j^2;
                X_C(k,5)=i*j;
                Y_C(k,1)=1;
                Y_C(k,2)=j;
                Y_C(k,3)=i;
                Y_C(k,4)=i*j;
                Y_C(k,5)=i^2;
                Y_prim_C(k,1)=b(i,j);
                Y_prim_C(k,2)=b(i,j)+i;
                Y_prim_C(k,3)=j;
                Y_prim_C(k,4)=i;
                k=k+1;
            end 
        end
    end

    k=1;
    for i=1:size(c,1) %1-rows 2-columns
        for j=1:size(c,2)
            if ~ c(i,j)==0
                if Y_prim_C(k,3)==j && Y_prim_C(k,4)==i
                    Y_prim_C(k,5)=c(i,j);
                    Y_prim_C(k,6)=c(i,j)+j;
                end
                k=k+1;
            end 
        end
    end

    wektorA=[];
    wektorB=[];

    for i=1:size(Y_prim_C,1) %1-rows 2-columns
        wektorA(i,1)=(Y_prim_C(i,6)*(Y_prim_C(i,6)^2+Y_prim_C(i,2)^2))-(Y_prim_C(i,3)*(Y_prim_C(i,3)^2+Y_prim_C(i,4)^2));
        wektorB(i,1)=(Y_prim_C(i,2)*(Y_prim_C(i,6)^2+Y_prim_C(i,2)^2))-(Y_prim_C(i,4)*(Y_prim_C(i,3)^2+Y_prim_C(i,4)^2));
    end
    D=[Y_prim_C(:,5);Y_prim_C(:,1)];
    X=[X_C zeros(size(X_C,1),5) wektorA; zeros(size(Y_C,1),5) Y_C wektorB];
    p=((X.'*X)^-1)*X.'*D;

    %% calculation for ROI
    x_org_data=u_roi;
    y_org_data=v_roi;

    x_cor_data=[];
    y_cor_data=[];
    for i=1:size(x_org_data,1)
       for j=1:size(x_org_data,2)
            if x_org_data(i,j)==0
               x_cor_data(i,j)=0;
            else
               x_temp=j+x_org_data(i,j); 
               y_temp=i+y_org_data(i,j);
               x_cor_data(i,j)=x_org_data(i,j)-p(2)*j-p(3)*i-p(4)*j^2-p(5)*i*j+p(11)*(x_temp*(x_temp^2+y_temp^2)-j*(j^2+i^2));
             end
       end
    end

    for i=1:size(y_org_data,1)
       for j=1:size(y_org_data,2)
            if y_org_data(i,j)==0
               y_cor_data(i,j)=0;
            else
               x_temp=j+x_org_data(i,j); 
               y_temp=i+y_org_data(i,j);
               y_cor_data(i,j)=y_org_data(i,j)-p(7)*j-p(8)*i-p(9)*j*i-p(10)*i^2+p(11)*(y_temp*(x_temp^2+y_temp^2)-i*(j^2+i^2));
            end
       end
    end
    
    for i=1:size(c,1)
       for j=1:size(c,2)
            if c(i,j)==0
               x_cor_data_roc(i,j)=0;
            else
               x_temp=j+c(i,j); 
               y_temp=i+c(i,j);
               x_cor_data_roc(i,j)=c(i,j)-p(2)*j-p(3)*i-p(4)*j^2-p(5)*i*j+p(11)*(x_temp*(x_temp^2+y_temp^2)-j*(j^2+i^2));
             end
       end
    end
    
    for i=1:size(b,1)
       for j=1:size(b,2)
            if b(i,j)==0
               y_cor_data_roc(i,j)=0;
            else
               x_temp=j+b(i,j); 
               y_temp=i+b(i,j);
               y_cor_data_roc(i,j)=b(i,j)-p(7)*j-p(8)*i-p(9)*j*i-p(10)*i^2+p(11)*(y_temp*(x_temp^2+y_temp^2)-i*(j^2+i^2));
            end
       end
    end
    
    u_corrected = x_cor_data;
    v_corrected = y_cor_data;
    
    u_corrected_roc = x_cor_data_roc;
    v_corrected_roc = y_cor_data_roc;
end




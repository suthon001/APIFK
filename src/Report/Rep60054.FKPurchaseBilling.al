/// <summary>
/// Report FK Purchase Billing (ID 60054).
/// </summary>
report 60054 "FK Purchase Billing"
{
    DefaultLayout = RDLC;
    Caption = 'Purchase Billing';
    RDLCLayout = './LayoutReport/PurchaseBilling.rdl';
    UsageCategory = None;
    dataset
    {
        dataitem("Billing - Receipt Header"; "TPP Billing - Receipt Header")
        {
            RequestFilterFields = "TPP Document Type", "TPP No.";
            CalcFields = "TPP total Amount";
            column(CompName; ComInfo.Name + ComInfo."Name 2") { }
            column(CompAdd; ComInfo.Address) { }
            column(CompAdd2; ComInfo."Address 2" + ' ' + ComInfo.City + ' ' + ComInfo."Post Code") { }
            column(CompPicture; ComInfo.Picture) { }
            column(CompPhone; ComInfo."Phone No.") { }
            column(ComFax; ComInfo."Fax No.") { }
            column(ComTaxID; ComInfo."VAT Registration No.") { }
            column(ComMail; ComInfo."E-Mail") { }
            column(BuyFromCode; "TPP Vendor No.") { }
            column(BuyFromName; "TPP Vendor Name" + "TPP Vendor Name 2") { }
            column(BuyFromAdd; "TPP Vendor Address") { }
            column(BuyFromAdd2; STRSUBSTNO('%1 %2 %3', "TPP Vendor Address 2", "TPP Vendor City", "TPP Vendor Post Code")) { }
            column(BuyFromPhone; VendPhone) { }
            column(BuyFromFax; VendFax) { }
            column(DocumentNo; "TPP No.") { }
            column(DocumentDate; FORMAT("TPP Document Date")) { }
            column(VendTaxID; Vendor."VAT Registration No.") { }
            column(PaymentTermDesc; PaymentTerm.Description) { }
            column(AmountTh; AmountTh) { }
            column(DocumentVATAmount; "TPP Total Amount") { }
            column(DOcDueDate; FORMAT("TPP Due Date")) { }

            dataitem("Billing - Receipt Line"; "TPP Billing - Receipt Line")
            {
                DataItemTableView = SORTING("TPP Document Type", "TPP Document No.", "TPP Line No.");
                DataItemLink = "TPP Document Type" = FIELD("TPP Document Type"), "TPP Document No." = FIELD("TPP No.");
                column(VendDocDate; FORMAT("TPP Vendor Doc. Date")) { }
                column(VendDocNo; "TPP Vendor Doc. No.") { }
                column(VendExDocNo; "TPP Vendor Ext. Doc. No.") { }
                column(VendDueDate; FORMAT("TPP Vendor Due Date")) { }
                column(VendAmt; "TPP Amount (LCY)") { }
                column(Output; Output) { }
                column(DataOFLine; DataOFLine) { }
                trigger OnPreDataItem()
                begin
                    CLEAR(ItemLine);
                end;

                trigger OnAfterGetRecord()
                begin
                    ItemLine += 1;
                    DataOFLine += 1;

                    IF DataOFLine > MaxRow THEN BEGIN
                        Output := Output + 1;
                        DataOFLine := 0;

                    END;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                IF Vendor.GET("TPP Vendor No.") THEN BEGIN
                    VendPhone := 'TEL.         ' + Vendor."Phone No.";
                    VendFax := 'FAX. ' + Vendor."Fax No.";
                END;

                IF NOT PaymentTerm.GET("TPP Payment Term Code") THEN
                    PaymentTerm.INIT();
                IF "TPP Currency Code" = '' THEN
                    AmountTh := LocalFunction."TPP FormatNoThaiText"("TPP Total Amount")
                ELSE
                    AmountTh := LocalFunction."TPP FormatNoEngextCurr"("TPP Total Amount", "TPP Currency Code");
            end;

        }
    }
    trigger OnPreReport()
    begin
        ComInfo.GET();
        ComInfo.CALCFIELDS(Picture);
        MaxRow := 23;

    end;

    var
        ComInfo: Record "Company Information";

        DataOFLine: Integer;
        Output: Integer;
        Vendor: Record "Vendor";
        VendPhone: Text[50];
        VendFax: Text[50];

        MaxRow: Integer;


        PaymentTerm: Record "Payment Terms";
        LocalFunction: Codeunit "TPP Localized Function";
        AmountTh: Text[1024];

        ItemLine: Integer;


}
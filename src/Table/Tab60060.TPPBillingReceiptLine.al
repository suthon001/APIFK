table 60060 "TPP Billing - Receipt Line"
{
    Caption = 'Billing - Receipt Lines';
    fields
    {
        field(1; "TPP Document Type"; Enum "TPP Document Type")
        {
            Caption = 'Document Type';
            // OptionCaption = 'Billing,Receipt,P. Billing'; //KT
            // OptionMembers = Billing,Receipt,"P. Billing";
            DataClassification = SystemMetadata;
        }
        field(2; "TPP Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "TPP Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(4; "TPP Cust. Entry No."; Integer)
        {
            Caption = 'Cust. Entry No.';
            DataClassification = SystemMetadata;
        }
        field(5; "TPP Cust. Doc. Date"; Date)
        {
            Caption = 'Cust. Doc. Date';
            DataClassification = SystemMetadata;
        }
        field(6; "TPP Cust. Doc. No."; Code[20])
        {
            Caption = 'Cust. Doc. No.';
            DataClassification = SystemMetadata;
        }
        field(7; "TPP Cust. Ext. Doc. No."; Code[35])
        {
            Caption = 'Cust. Ext. Doc. No.';
            DataClassification = SystemMetadata;
        }
        field(8; "TPP Cust. Due Date"; Date)
        {
            Caption = 'Cust. Due Date';
            DataClassification = SystemMetadata;
        }
        field(9; "TPP Original Amount (LCY)"; Decimal)
        {
            Caption = 'Original Amount (LCY)';
            DataClassification = SystemMetadata;
        }
        field(10; "TPP Remaining Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)';
            DataClassification = SystemMetadata;
        }
        field(11; "TPP Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgerEntry: Record "Vendor Ledger Entry";
                IsHandled: Boolean;
            begin
                // Ton 2022-04-27 ++
                IsHandled := false;
                OnBeforeValidateAmountLCY(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;
                // Ton 2022-04-27 --

                IF "TPP Document Type" = "TPP Document Type"::Receipt THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    CustLedgEntry.GET("TPP Cust. Entry No.");
                    //"Remaining Amount (LCY)" := CustLedgEntry."Cust. Rec. Rem. Amt. (LCY)"+"Remaining Amount (LCY)";
                    IF "TPP Amount (LCY)" > "TPP Remaining Amount (LCY)" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount (LCY)");
                        "TPP Amount (LCY)" := xRec."TPP Amount (LCY)";
                    END ELSE
                        BillRemMgt."TPP UpdateCustOutstandingfromrec"("TPP Cust. Entry No.", "TPP Amount (LCY)", xRec."TPP Amount (LCY)");
                end;

                IF "TPP Document Type" = "TPP Document Type"::Billing THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    CustLedgEntry.GET("TPP Cust. Entry No.");
                    IF "TPP Amount (LCY)" > "TPP Remaining Amount (LCY)" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount (LCY)");
                        "TPP Amount (LCY)" := xRec."TPP Amount (LCY)";
                    END ELSE
                        BillRemMgt."TPP UpdateCustOutstandingfromrecBilling"("TPP Cust. Entry No.", "TPP Amount (LCY)", xRec."TPP Amount (LCY)");
                END;

                //TPP.SSI 2022/03/18++
                IF "TPP Document Type" = "TPP Document Type"::"P. Billing" THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    VendLedgerEntry.GET("TPP Vendor Entry No.");
                    IF "TPP Amount (LCY)" > "TPP Remaining Amount (LCY)" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount (LCY)");
                        "TPP Amount (LCY)" := xRec."TPP Amount (LCY)";
                    END ELSE
                        BillRemMgt."TPP UpdateVendOutstandingfromrec"("TPP Vendor Entry No.", "TPP Amount (LCY)", xRec."TPP Amount (LCY)");
                end;
                //TPP.SSI 2022/03/18--

            end;
        }
        field(12; "TPP Vendor Entry No."; Integer)
        {
            Caption = 'Vendor Entry No.';
            DataClassification = SystemMetadata;
        }
        field(13; "TPP Vendor Doc. Date"; Date)
        {
            Caption = 'Vendor Doc. Date';
            DataClassification = SystemMetadata;
        }
        field(14; "TPP Vendor Doc. No."; Code[20])
        {
            Caption = 'Vendor Doc. No.';
            DataClassification = SystemMetadata;
        }
        field(15; "TPP Vendor Ext. Doc. No."; Code[35])
        {
            Caption = 'Vendor Ext. Doc. No.';
            DataClassification = SystemMetadata;
        }
        field(16; "TPP Vendor Due Date"; Date)
        {
            Caption = 'Vendor Due Date';
            DataClassification = SystemMetadata;
        }
        field(17; "TPP Original Amount"; Decimal)
        {
            Caption = 'Original Amount';
            DataClassification = SystemMetadata;
        }
        field(18; "TPP Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            DataClassification = SystemMetadata;
        }
        field(19; "TPP Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                BillngUnit: Codeunit "FK Billing - Receipt Mgt.";
                VendLedgerEntry: Record "Vendor Ledger Entry";
                IsHandled: Boolean;
            begin
                // Ton 2022-04-27 ++
                IsHandled := false;
                OnBeforeValidateAmount(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;
                // Ton 2022-04-27 --

                Commit(); //TPP.SSI 2022/03/31
                IF "TPP Document Type" = "TPP Document Type"::Receipt THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    CustLedgEntry.GET("TPP Cust. Entry No.");
                    //"Remaining Amount" := CustLedgEntry."Cust. Rec. Rem. Amt."+"Remaining Amount";
                    IF "TPP Amount" > "TPP Remaining Amount" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount");
                        "TPP Amount" := xRec."TPP Amount";
                    END ELSE
                        BillRemMgt."TPP UpdateCustOutstandingfromrec"("TPP Cust. Entry No.", "TPP Amount", xRec."TPP Amount");
                end;
                IF "TPP Document Type" = "TPP Document Type"::Billing THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    CustLedgEntry.GET("TPP Cust. Entry No.");
                    //"Remaining Amount" := CustLedgEntry."Cust. Rec. Rem. Amt."+"Remaining Amount";
                    IF "TPP Amount" > "TPP Remaining Amount" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount");
                        "TPP Amount" := xRec."TPP Amount";
                    END ELSE
                        BillRemMgt."TPP UpdateCustOutstandingfromrecBilling"("TPP Cust. Entry No.", "TPP Amount", xRec."TPP Amount");
                END;
                //TPP.SSI 2022/03/18++
                IF "TPP Document Type" = "TPP Document Type"::"P. Billing" THEN BEGIN
                    BillingHeader.GET("TPP Document Type", "TPP Document No.");
                    BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
                    VendLedgerEntry.GET("TPP Vendor Entry No.");
                    IF "TPP Amount" > "TPP Remaining Amount" THEN BEGIN
                        MESSAGE('Amount must less than %1', "TPP Remaining Amount");
                        "TPP Amount" := xRec."TPP Amount";
                    END ELSE
                        BillRemMgt."TPP UpdateVendOutstandingfromrec"("TPP Vendor Entry No.", "TPP Amount", xRec."TPP Amount");
                end;
                //TPP.SSI 2022/03/18--

            end;
        }
        field(20; "TPP Cust. Doc. Type"; Option)
        {
            Caption = 'Cust. Doc. Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";
            DataClassification = SystemMetadata;
        }
        field(21; "TPP Quantity"; Decimal)
        {
            Caption = 'Temp. Quantity';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(22; "TPP Unit Price"; Decimal)
        {
            Caption = 'Temp. Unit Price';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(23; "TPP Line Discount %"; Decimal)
        {
            Caption = 'Temp. ine Discount %';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(24; "TPP Line Discount Amount"; Decimal)
        {
            Caption = 'Temp. Quantity';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(25; "TPP Line Amount"; Decimal)
        {
            Caption = 'Temp. Line Amount';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(26; "TPP UOM"; Code[30])
        {
            Caption = 'Temp. UOM';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(27; "TPP Inv. Discount Amount"; Decimal)
        {
            Caption = 'Temp. Inv. Discount Amount';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(28; "TPP No."; Code[30])
        {
            Caption = 'Temp. No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(29; "TPP Descreiption"; Text[100])
        {
            Caption = 'Descreiption';
            DataClassification = SystemMetadata;
            // Editable = false;
        }



    }
    keys
    {
        key(PK; "TPP Document Type", "TPP Document No.", "TPP Line No.")
        {
            Clustered = true;
        }
        key("1"; "TPP Document Type", "TPP Cust. Entry No.") { }
        key("2"; "TPP Document Type", "TPP Vendor Entry No.") { }
    }
    trigger OnDelete()
    begin
        BillingHeader.GET("TPP Document Type", "TPP Document No.");
        BillingHeader.TESTFIELD("TPP Status", BillingHeader."TPP Status"::Open);
        IF BillingHeader."TPP Document Type" = BillingHeader."TPP Document Type"::Receipt THEN
            BillRemMgt."TPP UpdateCustOutstandingfromdel"("TPP Cust. Entry No.", "TPP Amount (LCY)");

        IF BillingHeader."TPP Document Type" = BillingHeader."TPP Document Type"::Billing THEN
            BillRemMgt."TPP UpdateCustOutstandingfromdelBilling"("TPP Cust. Entry No.", "TPP Amount (LCY)");

        //TPP.SSI 2022/03/18++
        IF BillingHeader."TPP Document Type" = BillingHeader."TPP Document Type"::"P. Billing" THEN
            BillRemMgt."TPP UpdateVendOutstandingfromdel"("TPP Vendor Entry No.", "TPP Amount (LCY)");
        //TPP.SSI 2022/03/18--

    end;

    var
        BillingHeader: Record "TPP Billing - Receipt Header";
        BillRemMgt: Codeunit "FK Billing - Receipt Mgt.";

    // Ton 2022-04-27 ++
    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateAmountLCY(var Rec: Record "TPP Billing - Receipt Line"; xRec: Record "TPP Billing - Receipt Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateAmount(var Rec: Record "TPP Billing - Receipt Line"; xRec: Record "TPP Billing - Receipt Line"; var IsHandled: Boolean)
    begin
    end;
    // Ton 2022-04-27 --
}
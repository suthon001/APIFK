/// <summary>
/// Table TPP Billing - Receipt Header (ID 60059).
/// </summary>
table 60059 "TPP Billing - Receipt Header"
{
    Caption = 'Billing - Receipt Header';
    fields
    {
        field(1; "TPP Document Type"; Enum "TPP Document Type")
        {
            Caption = 'Document Type';
            // OptionCaption = 'Billing,Receipt,P. Billing'; //KT 
            // OptionMembers = Billing,Receipt,"P. Billing";
            DataClassification = SystemMetadata;
        }
        field(2; "TPP No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; "TPP Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                TestStatusOpen();
                IF Customer.GET("TPP Customer No.") THEN BEGIN
                    "TPP Customer Name" := Customer.Name;
                    "TPP Customer Name 2" := Customer."Name 2";
                    "TPP Customer Address" := Customer.Address;
                    "TPP Customer Address 2" := Customer."Address 2";
                    "TPP Head Office" := Customer."TPP Head Office";
                    "TPP City" := Customer.City;
                    "TPP Branch Code" := Customer."TPP Branch Code";
                    "VAT Registration No." := Customer."VAT Registration No.";// Ton 2021-02-03
                    "E-mail" := Customer."E-Mail"; //TPP.SSI 2022/03/03
                    "TPP Post Code" := Customer."Post Code";
                    IF Customer."Payment Method Code" <> '' THEN
                        VALIDATE("TPP Payment Method", Customer."Payment Method Code");
                    IF Customer."Payment Terms Code" <> '' THEN
                        VALIDATE("TPP Payment Term Code", Customer."Payment Terms Code");
                END;
            end;
        }
        field(4; "TPP Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(5; "TPP Customer Name 2"; Text[100])
        {
            Caption = 'Customer Name 2';
            DataClassification = CustomerContent;
        }
        field(6; "TPP Customer Address"; Text[100])
        {
            Caption = 'Customer Address';
            DataClassification = CustomerContent;
        }
        field(7; "TPP Customer Address 2"; Text[100])
        {
            Caption = 'Customer Address 2';
            DataClassification = CustomerContent;
        }
        field(8; "TPP City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(9; "TPP Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(10; "TPP Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF ("TPP Document Date" <> xRec."TPP Document Date") AND ("TPP Document Date" <> 0D) THEN
                    IF PaymentTerm.GET("TPP Payment Term Code") THEN
                        "TPP Due Date" := CALCDATE(PaymentTerm."Due Date Calculation", "TPP Document Date");
            end;
        }
        field(11; "TPP Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(12; "TPP Payment Method"; Code[20])
        {
            Caption = 'Payment Method';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method".Code;
            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                TestStatusOpen();
                IF PaymentMethod.GET("TPP Payment Method") THEN
                    "TPP Payment Option" := PaymentMethod."TPP Payment Option";

                IF ("TPP Document Date" <> 0D) THEN
                    IF PaymentTerm.GET("TPP Payment Term Code") THEN
                        "TPP Due Date" := CALCDATE(PaymentTerm."Due Date Calculation", "TPP Document Date");

            end;
        }
        field(13; "TPP Payment Option"; Option)
        {
            Caption = 'Payment Option';
            OptionCaption = 'Cash,Cheque,Transfer,Credit Card';
            OptionMembers = Cash,Cheque,Transfer,"Credit Card";
            DataClassification = CustomerContent;
        }
        field(14; "TPP Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('BANK'));
            trigger OnValidate()
            begin
                TestStatusOpen();
                IF DimValue.GET('BANK', "TPP Bank Code") THEN
                    "TPP Bank Name" := DimValue.Name;
            end;
        }
        field(15; "TPP Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(16; "TPP Bank Branch Code"; Code[20])
        {
            Caption = 'Bank Branch Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('BANKBRANCH'));
            trigger OnValidate()
            begin
                TestStatusOpen();
                IF DimValue.GET('BANKBRANCH', "TPP Bank Branch Code") THEN
                    "TPP Bank Branch Name" := DimValue.Name;
            end;
        }
        field(17; "TPP Bank Branch Name"; Text[50])
        {
            Caption = 'Bank Branch Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(18; "TPP Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(19; "TPP Receive Amount"; Decimal)
        {
            Caption = 'Receive Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(20; "TPP Status"; Enum "TPP Status")
        {
            Caption = 'Status';
            // OptionCaption = 'Open,Released,Create RV';
            // OptionMembers = Open,Released,"Create RV";
            DataClassification = SystemMetadata;
        }
        field(21; "TPP Receive Voucher No."; Code[20])
        {
            Caption = 'Receive Voucher No.';
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;

            trigger OnLookup()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                GenJnlLine.RESET();
                GenJnlLine.FILTERGROUP := 2;
                GenJnlLine.SETRANGE("Journal Template Name", "TPP Template Name");
                GenJnlLine.FILTERGROUP := 0;
                GenJnlLine.SETRANGE("Journal Batch Name", "TPP Batch Name");
                GenJnlLine."Journal Template Name" := '';
                GenJnlLine."Journal Batch Name" := "TPP Batch Name";
                GenJnlLine.SETFILTER("Document No.", '%1', "TPP Journal Document No.");
                PAGE.RUN(PAGE::"Cash Receipt Journal", GenJnlLine);
            end;
        }
        field(22; "TPP Total Amount (LCY)"; Decimal)
        {
            Caption = 'Total Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TPP Billing - Receipt Line"."TPP Amount (LCY)" WHERE("TPP Document Type" = FIELD("TPP Document Type"), "TPP Document No." = FIELD("TPP No.")));
            //DataClassification = SystemMetadata;
        }
        field(23; "TPP No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
        }
        field(24; "TPP Payment Term Code"; Code[10])
        {
            Caption = 'Billing Term Code';
            TableRelation = "Payment Terms".Code;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF PaymentTerm.GET("TPP Payment Term Code") THEN
                    IF "TPP Document Date" <> 0D THEN
                        "TPP Due Date" := CALCDATE(PaymentTerm."Due Date Calculation", "TPP Document Date");
            end;
        }
        field(25; "TPP Receive Type"; Option)
        {
            Caption = 'Receive Type';
            OptionCaption = 'Bank Account,G/L Account';
            OptionMembers = "Bank Account","G/L Account";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(26; "TPP Receive Account No."; Code[20])
        {
            Caption = 'Receive Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("TPP Receive Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("TPP Receive Type" = CONST("G/L Account")) "G/L Account";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(27; "TPP Receive Date"; Date)
        {
            Caption = 'Receive Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(28; "TPP Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                IF "TPP Currency Code" <> xRec."TPP Currency Code" THEN BEGIN
                    BillingLine.RESET();
                    BillingLine.SETRANGE("TPP Document Type", "TPP Document Type");
                    BillingLine.SETRANGE("TPP Document No.", "TPP No.");
                    IF BillingLine.FindFirst() THEN
                        ERROR('Document Line already exists');
                END;
            end;
        }
        field(29; "TPP Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(30; "TPP Prepaid WHT Acc."; Code[20])
        {
            Caption = 'Prepaid WHT Acc.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(31; "TPP Prepaid WHT Amount (LCY)"; Decimal)
        {
            Caption = 'Prepaid WHT Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(32; "TPP Diff Amount Acc."; Code[20])
        {
            Caption = 'Diff Amount Acc.';
            DataClassification = CustomerContent;
        }
        field(33; "TPP Bank Fee Acc."; Code[20])
        {
            Caption = 'Bank Fee Acc.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(34; "TPP Bank Fee Amount (LCY)"; Decimal)
        {
            Caption = 'Bank Fee Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(35; "TPP Prepaid WHT Date"; Date)
        {
            Caption = 'Prepaid WHT Date';
            DataClassification = CustomerContent;
        }
        field(36; "TPP Prepaid WHT No."; Code[20])
        {
            Caption = 'Prepaid WHT No.';
            DataClassification = CustomerContent;
        }
        field(37; "TPP Diff Amount (LCY)"; Decimal)
        {
            Caption = 'Diff Amount (LCY)';
            DataClassification = SystemMetadata;
        }
        field(38; "TPP Receive Status"; Option)
        {
            Caption = 'Receive Status';
            OptionCaption = ' ,In used,Used';
            OptionMembers = " ","In used",Used;
            DataClassification = SystemMetadata;
        }
        field(39; "TPP Template Name"; Code[20])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(40; "TPP Batch Name"; Code[10])
        {

            Caption = 'Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("TPP Template Name"));
            trigger OnValidate()
            begin
                TestField("TPP Template Name");
            end;
        }
        field(41; "TPP RV No. Series"; Code[20])
        {
            Caption = 'RV No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(42; "TPP Journal Document No."; Code[20])
        {
            Caption = 'Journal Document No.';
            DataClassification = SystemMetadata;

            // trigger OnLookup()
            // var
            //     GenJnlLine: Record "Gen. Journal Line";
            // begin
            //     GenJnlLine.RESET;
            //     GenJnlLine.FILTERGROUP := 2;
            //     GenJnlLine.SETRANGE("Journal Template Name", "TPP Template Name");
            //     GenJnlLine.FILTERGROUP := 0;
            //     GenJnlLine.SETRANGE("Journal Batch Name", "TPP Batch Name");
            //     GenJnlLine."Journal Template Name" := '';
            //     GenJnlLine."Journal Batch Name" := "TPP Batch Name";
            //     GenJnlLine.SETFILTER("Document No.", '%1', "TPP Journal Document No.");
            //     PAGE.RUN(PAGE::"Cash Receipt Journal", GenJnlLine);
            // end;
        }
        field(43; "TPP Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            DataClassification = SystemMetadata;
        }
        field(44; "TPP Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                TestStatusOpen();
                IF Vendor.GET("TPP Vendor No.") THEN BEGIN
                    "TPP Vendor Name" := Vendor.Name;
                    "TPP Vendor Name 2" := Vendor."Name 2";
                    "TPP Vendor Address" := Vendor.Address;
                    "TPP Vendor Address 2" := Vendor."Address 2";
                    "TPP Vendor City" := Vendor.City;
                    "TPP Vendor Post Code" := Vendor."Post Code";
                    "TPP Payment Term Code" := Vendor."Payment Terms Code";
                    "TPP Payment Method" := Vendor."Payment Method Code";
                    "TPP Currency Code" := Vendor."Currency Code";
                    "TPP Head Office" := Vendor."TPP Head Office";
                    "TPP Branch Code" := Vendor."TPP Branch Code";
                    "VAT Registration No." := Vendor."VAT Registration No.";// Ton 2021-02-03
                    "TPP City" := Vendor.City;
                    "TPP Post Code" := Vendor."Post Code";

                END;
            end;
        }
        field(45; "TPP Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(46; "TPP Vendor Name 2"; Text[50])
        {
            Caption = 'Vendor Name 2';
            DataClassification = CustomerContent;
        }
        field(47; "TPP Vendor Address"; Text[100])
        {
            Caption = 'Vendor Address';
            DataClassification = CustomerContent;
        }
        field(48; "TPP Vendor Address 2"; Text[100])
        {
            Caption = 'Vendor Address 2';
            DataClassification = CustomerContent;
        }
        field(49; "TPP Vendor City"; Text[30])
        {
            Caption = 'Vendor City';
            DataClassification = CustomerContent;
        }
        field(50; "TPP Vendor Post Code"; Code[20])
        {
            Caption = 'Vendor Post Code';
            DataClassification = CustomerContent;
        }
        field(51; "TPP Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TPP Billing - Receipt Line"."TPP Amount" WHERE("TPP Document Type" = FIELD("TPP Document Type"), "TPP Document No." = FIELD("TPP No.")));
        }
        field(52; "TPP Remark"; Text[100])
        {
            Caption = 'Remark';
            DataClassification = CustomerContent;
        }
        field(53; "TPP Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(54; "TPP Branch Code"; Code[10])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "TPP Branch Code" <> '' then
                    "TPP Head Office" := false;
            end;
        }
        field(55; "TPP Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Discount Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(56; "TPP Discount Amount Acc."; Code[20])
        {
            Caption = 'Discount Amount Acc.';
            DataClassification = CustomerContent;
        }
        field(57; "TPP Transport Amount (LCY)"; Decimal)
        {
            Caption = 'Transport Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(58; "TPP Transport Amount Acc."; Code[20])
        {
            Caption = 'Transport Amount Acc.';
            DataClassification = CustomerContent;
        }
        field(59; "TPP Advertise Amount (LCY)"; Decimal)
        {
            Caption = 'Advertise Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(60; "TPP Advertise Amount Acc."; Code[20])
        {
            Caption = 'Advertise Amount Acc.';
            DataClassification = CustomerContent;
        }
        field(61; "TPP Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "TPP Head Office" then
                    "TPP Branch Code" := '';
            end;
        }
        field(62; "TPP Commit Date"; Date)
        {
            Caption = 'Commit Date';
            DataClassification = CustomerContent;
        }
        // Ton 2021-02-03 ++
        field(63; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "VAT Registration No." := UpperCase("VAT Registration No.");
            end;
        }
        // Ton 2021-02-03 --
        field(64; "E-mail"; text[80]) //TPP.SSI 2022/03/03
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
    }
    keys
    {
        key(PK; "TPP Document Type", "TPP No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        GenBatch: Record "Gen. Journal Batch";
    begin
        SalesSetup.GET();
        PurchSetup.GET();
        IF "TPP No." = '' THEN BEGIN
            IF "TPP Document Type" = "TPP Document Type"::Billing THEN BEGIN
                SalesSetup.TESTFIELD("TPP Sales Billing Nos.");
                SeriesCode := SalesSetup."TPP Sales Billing Nos.";
            END;
            IF "TPP Document Type" = "TPP Document Type"::Receipt THEN BEGIN
                SalesSetup.TESTFIELD("TPP Sales Receipt Nos.");
                SeriesCode := SalesSetup."TPP Sales Receipt Nos.";
            END;
            IF "TPP Document Type" = "TPP Document Type"::"P. Billing" THEN BEGIN
                PurchSetup.TESTFIELD("TPP Purchase Billing Nos.");
                SeriesCode := PurchSetup."TPP Purchase Billing Nos.";
            END;

            NoSeriesMgt.InitSeries(SeriesCode, xRec."TPP No. Series", WORKDATE(), "TPP No.", "TPP No. Series");
        END;
        "TPP Document Date" := WORKDATE();
        "TPP Due Date" := WORKDATE();
        IF "TPP Document Type" = "TPP Document Type"::Receipt THEN BEGIN
            "TPP Receive Type" := SalesSetup."TPP Defualt Receive Type";
            "TPP Receive Account No." := SalesSetup."TPP Default Receive Acc.";
            "TPP Prepaid WHT Acc." := SalesSetup."TPP Default Prepaid WHT Acc.";
            "TPP Diff Amount Acc." := SalesSetup."TPP Default Diff. Amt. Acc.";
            "TPP Bank Fee Acc." := SalesSetup."TPP Default Bank Fee Acc.";
            "TPP Template Name" := SalesSetup."TPP Default RV Template";
            "TPP Batch Name" := COPYSTR(SalesSetup."TPP Default RV Batch", 1, 10);
            if not GenBatch.GET("TPP Template Name", "TPP Batch Name") then
                GenBatch.init();
            "TPP RV No. Series" := GenBatch."TPP Document No. Series";
            // "Discount Amount Acc." := SalesSetup."Default Dis. Amt. Acc.";
            // "Advertise Amount Acc." := SalesSetup."Default Ad. Amt. Acc.";
            // "Transport Amount Acc." := SalesSetup."Default Tran. Amt. Acc.";
        END;
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
    end;

    trigger OnDelete()
    var
        BillReceiptLine: Record "TPP Billing - Receipt Line";
    begin
        TestStatusOpen();

        IF NOT CONFIRM(STRSUBSTNO('Do you want to delete no. %1', "TPP No.")) THEN
            EXIT;

        BillReceiptLine.RESET();
        BillReceiptLine.SETRANGE("TPP Document Type", "TPP Document Type");
        BillReceiptLine.SETRANGE("TPP Document No.", "TPP No.");
        BillReceiptLine.DELETEALL(TRUE);
    end;

    trigger OnRename()
    begin
        ERROR('You cannot rename this record');
    end;

    /// <summary>
    /// TestStatusOpen.
    /// </summary>
    procedure TestStatusOpen()
    begin
        if (xRec."TPP Status" = rec."TPP Status") and (rec."TPP Status" <> rec."TPP Status"::Open) then
            TESTFIELD("TPP Status", "TPP Status"::Open);
    end;

    /// <summary>
    /// TestStatusRelease.
    /// </summary>
    procedure TestStatusRelease()
    begin
        TESTFIELD("TPP Status", "TPP Status"::Released);
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldBillRcptHeader">Record "TPP Billing - Receipt Header".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldBillRcptHeader: Record "TPP Billing - Receipt Header"): Boolean
    var
        BIllRcptHeader: Record "TPP Billing - Receipt Header";
        BIllRcptHeader2: Record "TPP Billing - Receipt Header";
        IsHandled: Boolean; // Ton 2020/10/27
    begin
        // Ton 2020/10/27 ++
        IsHandled := false;
        OnBeforeAssistEdit(Rec, OldBillRcptHeader, IsHandled);
        if IsHandled then
            exit;
        // Ton 2020/10/27 --
        BIllRcptHeader.COPY(Rec);
        SalesSetup.GET();
        PurchSetup.GET();
        IF BIllRcptHeader."TPP Document Type" = BIllRcptHeader."TPP Document Type"::Billing THEN BEGIN
            SalesSetup.TESTFIELD("TPP Sales Billing Nos.");
            SeriesCode := SalesSetup."TPP Sales Billing Nos.";
        END;
        IF BIllRcptHeader."TPP Document Type" = BIllRcptHeader."TPP Document Type"::Receipt THEN BEGIN
            SalesSetup.TESTFIELD("TPP Sales Receipt Nos.");
            SeriesCode := SalesSetup."TPP Sales Receipt Nos.";
        END;
        IF BIllRcptHeader."TPP Document Type" = BIllRcptHeader."TPP Document Type"::"P. Billing" THEN BEGIN
            PurchSetup.TESTFIELD("TPP Purchase Billing Nos.");
            SeriesCode := PurchSetup."TPP Purchase Billing Nos.";
        END;
        IF NoSeriesMgt.SelectSeries(SeriesCode, OldBillRcptHeader."TPP No. Series", BIllRcptHeader."TPP No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(BIllRcptHeader."TPP No.");
            IF BIllRcptHeader2.GET(BIllRcptHeader."TPP Document Type", BIllRcptHeader."TPP No.") THEN
                ERROR(Text051, LOWERCASE(FORMAT(BIllRcptHeader."TPP Document Type")), BIllRcptHeader."TPP No.");
            Rec := BIllRcptHeader;
            EXIT(TRUE);
        END;

    end;

    /// <summary>
    /// CheckCashReceipt.
    /// </summary>
    procedure CheckCashReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenTemplate: Record "Gen. Journal Template";
        GenBatch: Record "Gen. Journal Batch";
    begin
        GenTemplate.GET("TPP Template Name");
        GenBatch.GET("TPP Template Name", "TPP Batch Name");
        GenJnlLine.SetRange("Journal Template Name", GenTemplate.Name);
        GenJnlLine.SetRange("Journal Batch Name", GenBatch.Name);
        GenJnlLine.SetRange("Ref.RV No.", "TPP No.");
        if not GenJnlLine.IsEmpty then
            Error('Cash Receipt Journals is not empty ,Document No. : %1', Rec."TPP Receive Voucher No.");
    end;

    // Ton 2020/10/27 ++

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var BillingReceiptHeader: Record "TPP Billing - Receipt Header"; OldBillingReceiptHeader: Record "TPP Billing - Receipt Header"; var IsHandled: Boolean)
    begin
    end;
    // Ton 2020/10/27 --

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeriesCode: Code[10];
        PaymentTerm: Record "Payment Terms";
        DimValue: Record "Dimension Value";
        BillingLine: Record "TPP Billing - Receipt Line";
        PurchSetup: Record "Purchases & Payables Setup";
        Text051: Label 'The sales %1 %2 already exists.', Locked = true;
}
/// <summary>
/// Page FK Vendor Ledger Page (ID 60073).
/// </summary>
page 60073 "FK Vendor Ledger Page"
{
    SourceTable = "Vendor Ledger Entry";
    // DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Entry No.") where("Document Type" = filter(Invoice | "Credit Memo"));
    Caption = 'Vendor Ledger Page';
    PageType = List;
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater("TPP GROUP")
            {
                field("TPP Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("TPP Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("TPP Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("TPP  Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("TPP Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("TPP Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("TPP Description"; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("TPP Original Amount"; -Rec."Original Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Amount field.';
                    Caption = 'Original Amoun';
                }
                field("TPP Remaining Amount"; -Rec."Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                    Caption = 'Remaining Amount';
                }
                //TPP.SSI 2022/03/18++
                // field("TPP Amount"; -Rec.Amount) { ApplicationArea = all; }
                field("TPP Vend. Bill. Rem. Amt.(LCY)"; -Rec."TPP Vend. Bill. Rem. Amt.(LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TPP Vend. Bill. Rem. Amt.(LCY) field.';
                    Caption = 'Vend. Bill. Rem. Amt.(LCY)';
                }
                field("TPP Vend. Bill. Amount (LCY)"; -Rec."TPP Vend. Bill. Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TPP Vend. Bill. Amount (LCY) field.';
                    Caption = 'Vend. Bill. Amount (LCY)';
                }
                field("TPP Vend. Billing Open"; Rec."TPP Vend. Billing Open")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vend. Billing Open field.';
                }
                //TPP.SSI 2022/03/18--

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Remaining Amount", "Original Amount", Amount, rec."TPP Vend. Bill. Amount (LCY)");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines();
    end;

    /// <summary>
    /// SetDocument.
    /// </summary>
    /// <param name="BillingRcptHeader">Record "TPP Billing - Receipt Header".</param>
    procedure SetDocument(BillingRcptHeader: Record "TPP Billing - Receipt Header")
    begin
        BillRcptHeader.GET(BillingRcptHeader."TPP Document Type", BillingRcptHeader."TPP No.");
    end;

    local procedure CreateLines()
    var
        VendEntry: Record "Vendor Ledger Entry";
        BillRcptLine: Record "TPP Billing - Receipt Line";
        GetCustRec: Codeunit "FK Billing - Receipt Mgt.";
    begin
        VendEntry.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(VendEntry);
        IF VendEntry.FindSet() THEN
            REPEAT
                //TPP.SSI 2022/03/18  TPP Vend. Bill. Amount (LCY)

                VendEntry.CALCFIELDS("TPP Vend. Bill. Amount (LCY)", Amount, "Original Amount", "Amount (LCY)", "Original Amt. (LCY)", "Remaining Amount", "Remaining Amt. (LCY)");
                IF (VendEntry."TPP Vend. Bill. Amount (LCY)" <= -VendEntry.Amount) and (VendEntry."Document Type" <> VendEntry."Document Type"::"Credit Memo") THEN BEGIN
                    BillRcptLine.INIT();
                    BillRcptLine."TPP Document Type" := BillRcptHeader."TPP Document Type";
                    BillRcptLine."TPP Document No." := BillRcptHeader."TPP No.";
                    BillRcptLine."TPP Line No." := GetLastLine();
                    BillRcptLine.INSERT();

                    BillRcptLine."TPP Vendor Entry No." := VendEntry."Entry No.";
                    BillRcptLine."TPP Vendor Doc. Date" := VendEntry."Document Date";
                    BillRcptLine."TPP Vendor Doc. No." := VendEntry."Document No.";
                    BillRcptLine."TPP Vendor Ext. Doc. No." := VendEntry."External Document No.";
                    BillRcptLine."TPP Vendor Due Date" := VendEntry."Due Date";
                    BillRcptLine."TPP Original Amount" := -VendEntry."Original Amount";
                    BillRcptLine."TPP Remaining Amount" := -VendEntry."Remaining Amount";
                    BillRcptLine."TPP Amount" := -VendEntry."Remaining Amount";

                    //TPP.SSI 2022/03/18++ ใช้ Cust. ไปได้เลย
                    if VendEntry."Document Type" = VendEntry."Document Type"::Invoice then
                        BillRcptLine."TPP Cust. Doc. Type" := BillRcptLine."TPP Cust. Doc. Type"::Invoice
                    else
                        BillRcptLine."TPP Cust. Doc. Type" := BillRcptLine."TPP Cust. Doc. Type"::"Credit Memo";
                    //TPP.SSI 2022/03/18--

                    //TPP.SSI 28/03/2022 ++
                    if BillRcptHeader."TPP Currency Code" <> '' then begin
                        BillRcptLine."TPP Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                        BillRcptLine."TPP Amount" := -VendEntry."Remaining Amount";
                    end else begin
                        BillRcptLine."TPP Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                        BillRcptLine."TPP Amount" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                    end;
                    BillRcptLine."TPP Original Amount (LCY)" := -VendEntry."Original Amt. (LCY)";
                    BillRcptLine."TPP Remaining Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                    //TPP.SSI 28/03/2022 --

                    //DekDong 20220302 ++
                    OnBeforModifyBillRcptLineNotCN(BillRcptLine, VendEntry);
                    //DekDong 20220302 --
                    BillRcptLine.MODIFY();
                END;
                //DekDong 20220302 ++
                IF (VendEntry."TPP Vend. Bill. Amount (LCY)" >= -VendEntry.Amount) and (VendEntry."Document Type" = VendEntry."Document Type"::"Credit Memo") THEN BEGIN
                    BillRcptLine.INIT();
                    BillRcptLine."TPP Document Type" := BillRcptHeader."TPP Document Type";
                    BillRcptLine."TPP Document No." := BillRcptHeader."TPP No.";
                    BillRcptLine."TPP Line No." := GetLastLine();
                    BillRcptLine.INSERT();

                    BillRcptLine."TPP Vendor Entry No." := VendEntry."Entry No.";
                    BillRcptLine."TPP Vendor Doc. Date" := VendEntry."Document Date";
                    BillRcptLine."TPP Vendor Doc. No." := VendEntry."Document No.";
                    BillRcptLine."TPP Vendor Ext. Doc. No." := VendEntry."External Document No.";
                    BillRcptLine."TPP Vendor Due Date" := VendEntry."Due Date";
                    BillRcptLine."TPP Original Amount" := -VendEntry."Original Amount";
                    BillRcptLine."TPP Remaining Amount" := -VendEntry."Remaining Amount";
                    BillRcptLine."TPP Amount" := -VendEntry."Remaining Amount";
                    //TPP.SSI 2022/03/18++ ใช้ Cust. ไปได้เลย
                    if VendEntry."Document Type" = VendEntry."Document Type"::Invoice then
                        BillRcptLine."TPP Cust. Doc. Type" := BillRcptLine."TPP Cust. Doc. Type"::Invoice
                    else
                        BillRcptLine."TPP Cust. Doc. Type" := BillRcptLine."TPP Cust. Doc. Type"::"Credit Memo";
                    //TPP.SSI 2022/03/18--

                    //TPP.SSI 28/03/2022 ++
                    if BillRcptHeader."TPP Currency Code" <> '' then begin
                        BillRcptLine."TPP Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                        BillRcptLine."TPP Amount" := -VendEntry."Remaining Amount";
                    end else begin
                        BillRcptLine."TPP Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                        BillRcptLine."TPP Amount" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                    end;
                    BillRcptLine."TPP Original Amount (LCY)" := -VendEntry."Original Amt. (LCY)";
                    BillRcptLine."TPP Remaining Amount (LCY)" := -VendEntry."TPP Vend. Bill. Rem. Amt.(LCY)";
                    //TPP.SSI 28/03/2022 --


                    //DekDong 20220302 ++
                    OnBeforModifyBillRcptLineCN(BillRcptLine, VendEntry);
                    //DekDong 20220302 --
                    BillRcptLine.MODIFY();
                END;
            //DekDong 20220302 --
            UNTIL VendEntry.NEXT() = 0;
        COMMIT();
        //TPP.SSI 2022/03/28++
        VendEntry.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(VendEntry);
        IF VendEntry.FindSet() THEN
            REPEAT
                GetCustRec."TPP UpdateVendOutstanding"(VendEntry."Entry No.");
            UNTIL VendEntry.NEXT() = 0;
        //TPP.SSI 2022/03/28--

    end;


    local procedure GetLastLine(): Integer;
    var
        BillRcptLine: Record "TPP Billing - Receipt Line";
    begin
        BillRcptLine.reset();
        BillRcptLine.SetFilter("TPP Document Type", '%1', BillRcptHeader."TPP Document Type");
        BillRcptLine.SetFilter("TPP Document No.", '%1', BillRcptHeader."TPP No.");
        if BillRcptLine.FindLast() then
            exit(BillRcptLine."TPP Line No." + 10000);
        exit(10000);
    end;

    var
        BillRcptHeader: Record "TPP Billing - Receipt Header";
    //DekDong 20220302 ++
    [IntegrationEvent(false, false)]
    local procedure OnBeforModifyBillRcptLineCN(Var BillRcptLine: Record "TPP Billing - Receipt Line"; var VendorLedgEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforModifyBillRcptLineNotCN(Var BillRcptLine: Record "TPP Billing - Receipt Line"; var VendorLedgEntry: Record "Vendor Ledger Entry")
    begin
    end;
    //DekDong 20220302 --
}
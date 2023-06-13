/// <summary>
/// Page FK Purch. Billing Subform (ID 60076).
/// </summary>
page 60076 "FK Purch. Billing Subform"
{

    PageType = ListPart;
    SourceTable = "TPP Billing - Receipt Line";
    InsertAllowed = false;
    AutoSplitKey = true;
    UsageCategory = None;
    Caption = 'Purch. Billing Subform';
    layout
    {
        area(Content)
        {
            repeater("TPP Group")
            {

                field("TPP Vendor Entry No."; Rec."TPP Vendor Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Entry No. field.';
                }
                field("TPP Vendor Doc. Date"; Rec."TPP Vendor Doc. Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Doc. Date field.';
                }
                field("TPP Vendor Doc. Type"; Rec."TPP Cust. Doc. Type") //TPP.SSI 2022/03/18
                {
                    Caption = 'Vendor Doc. Type';
                    ToolTip = 'Specifies the value of the Cust. Doc. Type field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("TPP Vendor Doc. No."; Rec."TPP Vendor Doc. No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Doc. No. field.';
                }
                field("TPP Vendor Ext. Doc. No."; Rec."TPP Vendor Ext. Doc. No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Ext. Doc. No. field.';
                }
                // field("TPP Original Amount"; Rec."TPP Original Amount")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                // field("TPP Remaining Amount"; Rec."TPP Remaining Amount")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                // field("TPP Amount"; Rec."TPP Amount")
                // {
                //     ApplicationArea = all;
                //     trigger OnValidate()
                //     begin
                //         CurrPage.Update();
                //     end;
                // }
                field("TPP Original Amount (LCY)"; Rec."TPP Original Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Original Amount (LCY) field.';
                    ApplicationArea = All;
                }
                field("TPP Remaining Amount (LCY)"; Rec."TPP Remaining Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Remaining Amount (LCY) field.';
                    ApplicationArea = All;
                }
                field("TPP Amount (LCY)"; Rec."TPP Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("TPP Get Vendor Ledger Entries")
            {
                Image = GetEntries;
                ApplicationArea = all;
                Caption = 'Get Vendor Ledger Entries';
                ToolTip = 'Executes the Get Vendor Ledger Entries action.';
                trigger OnAction()
                var
                    BillRcptHeader: Record "TPP Billing - Receipt Header";
                    BillRcptMgt: Codeunit "FK Billing - Receipt Mgt.";
                begin
                    BillRcptHeader.GET(Rec."TPP Document Type", Rec."TPP Document No.");

                    BillRcptHeader.TestField("TPP Status", BillRcptHeader."TPP Status"::Open); //TPP.SSI 2022/03/18

                    BillRcptMgt."TPP SetDocument"(BillRcptHeader);
                    BillRcptMgt."TPP GetVendLedgEntry"();
                    CurrPage.UPDATE();
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.UPDATE();
    end;
}
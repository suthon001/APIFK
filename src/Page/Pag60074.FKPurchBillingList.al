/// <summary>
/// Page FK Purch. Billing List (ID 60074).
/// </summary>
page 60074 "FK Purch. Billing List"
{

    PageType = List;
    SourceTable = "TPP Billing - Receipt Header";
    SourceTableView = sorting("TPP Document Type", "TPP No.") where("TPP Document Type" = const("P. Billing"));
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'Purch. Billing List';
    Editable = false;
    CardPageId = "FK Purch. Billing Card";
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater("TPP GROUP")
            {
                field("TPP No."; Rec."TPP No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("TPP Vendor No."; Rec."TPP Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("TPP Vendor Name"; Rec."TPP Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("TPP Vendor Name 2"; Rec."TPP Vendor Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name 2 field.';
                }
                field("TPP Vendor Address"; Rec."TPP Vendor Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Address field.';
                }
                field("TPP Vendor Address 2"; Rec."TPP Vendor Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Address 2 field.';
                }
                field("TPP Document Date"; Rec."TPP Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("TPP Due Date"; Rec."TPP Due Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("TPP Currency Code"; Rec."TPP Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("TPP Status"; Rec."TPP Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("TPP Total Amount (LCY)"; Rec."TPP Total Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Amount (LCY) field.';
                }
            }
        }
    }
}
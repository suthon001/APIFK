/// <summary>
/// PageExtension FK Posted Purchase Receipt (ID 60055) extends Record Posted Purchase Receipt.
/// </summary>
pageextension 60055 "FK Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(General)
        {
            field("Vendor No. Intranet"; Rec."Vendor No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("Purchase Receipt")
            {
                Caption = 'Purchase Receipt';
                Image = PrintReport;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purch. Rcpt. Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"TPP Purchase Receipt", true, false, PurchaseHeader);
                end;

            }
        }

    }
}

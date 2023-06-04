/// <summary>
/// PageExtension FK Posted Purchase Receipts (ID 60065) extends Record Posted Purchase Receipts.
/// </summary>
pageextension 60065 "FK Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
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
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Purchase Receipt action.';
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

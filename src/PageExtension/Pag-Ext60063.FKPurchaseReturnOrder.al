/// <summary>
/// PageExtension FK Purchase Return Order (ID 60063) extends Record Purchase Return Order.
/// </summary>
pageextension 60063 "FK Purchase Return Order" extends "Purchase Return Order"
{
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("Purchase Return Order")
            {
                Caption = 'Purchase Return Order';
                Image = PrintReport;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"TPP Purchase Return Order", true, false, PurchaseHeader);
                end;

            }
        }


    }
}

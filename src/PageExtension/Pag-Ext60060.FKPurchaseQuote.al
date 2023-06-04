/// <summary>
/// PageExtension FK Purchase Quote (ID 60060) extends Record Purchase Quote.
/// </summary>
pageextension 60060 "FK Purchase Quote" extends "Purchase Quote"
{
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action("Purchase Quotes")
            {
                Caption = 'Purchase Quote';
                Image = PrintReport;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Purchase Quote action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"TPP Purchase Quote", true, false, PurchaseHeader);
                end;

            }
        }

    }
}

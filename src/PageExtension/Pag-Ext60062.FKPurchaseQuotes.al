/// <summary>
/// PageExtension FK Purchase Quotes (ID 60062) extends Record Purchase Quotes.
/// </summary>
pageextension 60062 "FK Purchase Quotes" extends "Purchase Quotes"
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

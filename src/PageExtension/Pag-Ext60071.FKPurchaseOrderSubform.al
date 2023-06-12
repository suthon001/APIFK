/// <summary>
/// PageExtension FK Purchase Order Subform (ID 60071) extends Record Purchase Order Subform.
/// </summary>
pageextension 60071 "FK Purchase Order Subform" extends "Purchase Order Subform"
{
    actions
    {
        addafter(OrderTracking)
        {
            action("TPP Get PR Line")
            {
                ApplicationArea = all;
                Image = GetLines;
                Caption = 'Get PR Line';
                ToolTip = 'Executes the Get PR Line action.';
                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                    GetPR: Page "FK Get RR Line";
                begin
                    CLEAR(GetPR);
                    PurchHeader.GET(Rec."Document Type", Rec."Document No.");
                    PurchHeader.TESTFIELD(Status, PurchHeader.Status::Open);
                    PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Quote);
                    PurchLine.SETRANGE("TPP Status", PurchLine."TPP Status"::Released); // Ton 2021-10-19
                    PurchLine.SETFILTER("TPP OutStanding PR Quantity", '<>0');
                    GetPR.SETTABLEVIEW(PurchLine);
                    GetPR.LOOKUPMODE := TRUE;
                    GetPR.Editable := false;
                    GetPR."FK SetPurchHeader"(PurchHeader);
                    GetPR.RUNMODAL();
                    CLEAR(GetPR);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        PQLine: Record "Purchase Line";
        PQHeader: Record "Purchase Header";
    begin
        if PQLine.get(0, Rec."TPP Reference PR No.", Rec."TPP Reference PR Line No.") then
            if PQHeader.Get(0, Rec."TPP Reference PR No.") then begin
                PQHeader."TPP completed OutStanding Line" := false;
                PQHeader.Modify();
            end;
    end;
}

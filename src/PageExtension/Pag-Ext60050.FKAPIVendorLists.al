/// <summary>
/// PageExtension FK API Vendor Lists (ID 60050) extends Record Vendor List.
/// </summary>
pageextension 60050 "FK API Vendor Lists" extends "Vendor List"
{
    actions
    {
        addfirst(processing)
        {
            action(SendVendor)
            {
                Image = Vendor;
                Caption = 'Send API';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the Send API action.';
                trigger OnAction()
                var
                    ltVend: Record Vendor;
                    FKFunc: Codeunit "FK Func";
                    pVendorFilter: Text;
                begin
                    pVendorFilter := '';
                    ltVend.Copy(rec);
                    CurrPage.SetSelectionFilter(ltVend);
                    if ltVend.FindSet() then
                        repeat
                            if pVendorFilter <> '' then
                                pVendorFilter := pVendorFilter + '|';
                            pVendorFilter := pVendorFilter + ltVend."No.";
                        until ltVend.Next() = 0;
                    FKFunc.setDocumentNo(pVendorFilter);
                    FKFunc.callandsendvendorManual();
                end;
            }
        }
    }
}

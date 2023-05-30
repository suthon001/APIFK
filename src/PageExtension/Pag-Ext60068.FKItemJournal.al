pageextension 60068 "FK Item Journal" extends "Item Journal"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin
                if rec.AssistEdit(Xrec) then
                    CurrPage.Update();
            end;
        }
    }
}

/// <summary>
/// TableExtension FK API Vendor (ID 50090) extends Record Vendor.
/// </summary>
tableextension 50090 "FK API Vendor" extends Vendor
{
    fields
    {
        field(50090; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}

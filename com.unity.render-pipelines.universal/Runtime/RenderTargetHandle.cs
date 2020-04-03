using UnityEngine.Scripting.APIUpdating;

namespace UnityEngine.Rendering.Universal
{
    [MovedFrom("UnityEngine.Rendering.LWRP")] public struct RenderTargetHandle
    {
        public int id { set; get; }
        private RenderTargetIdentifier rtid { set; get; }

        public static readonly RenderTargetHandle CameraTarget = new RenderTargetHandle {id = -1 };

        public RenderTargetHandle(RenderTargetIdentifier renderTargetIdentifier)
        {
            id = -2;
            rtid = renderTargetIdentifier;
        }

        public void Init(string shaderProperty)
        {
            id = Shader.PropertyToID(shaderProperty);
        }

        public void Init(RenderTargetIdentifier renderTargetIdentifier)
        {
            id = -2;
            rtid = renderTargetIdentifier;
        }

        public RenderTargetIdentifier Identifier()
        {
            if (id == -1)
            {
                return BuiltinRenderTextureType.CameraTarget;
            }
            if(id == -2)
            {
                return rtid;
            }
            return new RenderTargetIdentifier(id);
        }

        public bool Equals(RenderTargetHandle other)
        {
            if (id == -2 || other.id == -2)
                return Identifier() == other.Identifier();
            return id == other.id;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            return obj is RenderTargetHandle && Equals((RenderTargetHandle)obj);
        }

        public override int GetHashCode()
        {
            return id;
        }

        public static bool operator==(RenderTargetHandle c1, RenderTargetHandle c2)
        {
            return c1.Equals(c2);
        }

        public static bool operator!=(RenderTargetHandle c1, RenderTargetHandle c2)
        {
            return !c1.Equals(c2);
        }
    }
}
